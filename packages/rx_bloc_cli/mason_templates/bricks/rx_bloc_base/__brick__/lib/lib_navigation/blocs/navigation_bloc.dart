{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_extensions.dart';
import '../../base/common_services/permissions_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/routers/router.dart';

part 'navigation_bloc.rxb.g.dart';

/// A contract class containing all events of the NavigationBloC.
abstract class NavigationBlocEvents {
  void goTo(RouteData route, {Object? extra});

  void pushTo(RouteData route, {Object? extra});
}

/// A contract class containing all states of the NavigationBloC.
abstract class NavigationBlocStates {
  /// The error state
  Stream<ErrorModel> get errors;

  ConnectableStream<void> get navigationPath;
}

@RxBloc()
class NavigationBloc extends $NavigationBloc {
  NavigationBloc({
    required GoRouter router,
    required PermissionsService permissionsService,
  })  : _router = router,
        _permissionsService = permissionsService {
    navigationPath.connect().addTo(_compositeSubscription);
  }

  final PermissionsService _permissionsService;
  final GoRouter _router;

  @override
  Stream<ErrorModel> _mapToErrorsState() =>
      errorState.mapToErrorModel().share();

  @override
  ConnectableStream<void> _mapToNavigationPathState() => Rx.merge([
    _$goToEvent
        .throttleTime(const Duration(seconds: 1))

    ///TODO: change it to switchMap or ....
        .flatMap(
          (routeData) => _permissionsService
          .checkPermission(routeData.route.permissionName)
          .then((_) => routeData)
          .asResultStream(),
    )
        .setErrorStateHandler(this)
        .whereSuccess()
        .map((args) =>
        _router.go(args.route.routeLocation, extra: args.extra)),
    _$pushToEvent
        .throttleTime(const Duration(seconds: 1))
        .flatMap(
          (routeData) => _permissionsService
          .checkPermission(routeData.route.permissionName)
          .then((_) => routeData)
          .asResultStream(),
    )
        .setErrorStateHandler(this)
        .whereSuccess()
        .map(
          (args) =>
          _router.push(args.route.routeLocation, extra: args.extra),
    ),
  ]).publish();
}

{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_extensions.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../router.dart';

part 'router_bloc.rxb.g.dart';

/// A contract class containing all events of the NavigationBloC.
abstract class RouterBlocEvents {
  void goTo(RouteData route, {Object? extra});

  void pushTo(RouteData route, {Object? extra});
}

/// A contract class containing all states of the NavigationBloC.
abstract class RouterBlocStates {
  /// The error state
  Stream<ErrorModel> get errors;

  ConnectableStream<void> get navigationPath;
}

@RxBloc()
class RouterBloc extends $RouterBloc {
  RouterBloc({
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
            .switchMap((routeData) => _go(routeData).asResultStream()),
        _$pushToEvent
            .throttleTime(const Duration(seconds: 1))
            .switchMap((routeData) => _push(routeData).asResultStream())
      ]).setErrorStateHandler(this).whereSuccess().publish();

  Future<void> _go(_GoToEventArgs routeData) async {
    await _permissionsService.checkPermission(routeData.route.permissionName);
    return _router.go(routeData.route.routeLocation, extra: routeData.extra);
  }

  Future<void> _push(_PushToEventArgs routeData) async {
    await _permissionsService.checkPermission(routeData.route.permissionName);
    return _router.push(routeData.route.routeLocation, extra: routeData.extra);
  }
}

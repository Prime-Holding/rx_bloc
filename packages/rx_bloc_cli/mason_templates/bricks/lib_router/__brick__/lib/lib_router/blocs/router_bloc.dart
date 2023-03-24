{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_extensions.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../models/route_data_model.dart';

part 'router_bloc.rxb.g.dart';

/// A contract class containing all events of the NavigationBloC.
abstract class RouterBlocEvents {
  /// Uses [GoRouter.go()] to navigates to given location with an optional
  /// [extra] object which can be passed as part of the navigation.
  ///
  /// See also:
  /// * [goToLocation] which navigates to given location.
  /// * [push] which pushes the location onto the page stack.
  void go(RouteDataModel route, {Object? extra});

  /// Navigates to given location.
  ///
  /// See also:
  /// * [go] which navigates to the location.
  /// * [push] which pushes the location onto the page stack.
  void goToLocation(String location);

  /// Uses [GoRouter.push()] to push the given location onto the page stack with
  /// an optional [extra] object which can be passed as part of the navigation.
  ///
  /// See also:
  /// * [go] which navigates to the location.
  /// * [goToLocation] which navigates to given location.
  void push(RouteDataModel route, {Object? extra});
}

/// A contract class containing all states of the NavigationBloC.
abstract class RouterBlocStates {
  /// The main state responsible for handling errors.
  ConnectableStream<ErrorModel> get errors;

  /// The state is updated when one of the navigation methods: [go], [push] or
  /// [goToLocation] are called.
  ConnectableStream<void> get navigationPath;
}

@RxBloc()
class RouterBloc extends $RouterBloc {
  RouterBloc({
    required GoRouter router,
    required PermissionsService permissionsService,
  })  : _router = router,
        _permissionsService = permissionsService {
    errors.connect().addTo(_compositeSubscription);
    navigationPath.connect().addTo(_compositeSubscription);
  }

  final PermissionsService _permissionsService;
  final GoRouter _router;

  @override
  ConnectableStream<ErrorModel> _mapToErrorsState() =>
      errorState.mapToErrorModel().publish();

  @override
  ConnectableStream<void> _mapToNavigationPathState() => Rx.merge([
        _$goEvent
            .throttleTime(const Duration(seconds: 1))
            .switchMap((routeData) => _go(routeData).asResultStream()),
        _$pushEvent
            .throttleTime(const Duration(seconds: 1))
            .switchMap((routeData) => _push(routeData).asResultStream()),
        _$goToLocationEvent.doOnData(_router.go).asResultStream(),
      ]).setErrorStateHandler(this).whereSuccess().publish();

  Future<void> _go(_GoEventArgs routeData) async {
    await _permissionsService.checkPermission(routeData.route.permissionName);
    return _router.go(routeData.route.routeLocation, extra: routeData.extra);
  }

  Future<void> _push(_PushEventArgs routeData) async {
    await _permissionsService.checkPermission(routeData.route.permissionName);
    await _router.push(routeData.route.routeLocation, extra: routeData.extra);
  }
}

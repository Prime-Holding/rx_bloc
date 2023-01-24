{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_extensions.dart';
import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/routers/router.dart';
import '../use_cases/check_permission_route_use_case.dart';

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
    required CoordinatorBlocType coordinatorBloc,
    required GoRouter router,
    required CheckPermissionRouteUseCase routePermissions,
  })  : _coordinatorBloc = coordinatorBloc,
        _router = router,
        _routePermissions = routePermissions {
    navigationPath.connect().addTo(_compositeSubscription);
  }

  final CoordinatorBlocType _coordinatorBloc;
  final CheckPermissionRouteUseCase _routePermissions;
  final GoRouter _router;

  @override
  Stream<ErrorModel> _mapToErrorsState() =>
      errorState.mapToErrorModel().share();

  @override
  ConnectableStream<void> _mapToNavigationPathState() => Rx.merge([
      _$goToEvent
        .throttleTime(const Duration(seconds: 1))
        .withLatestFrom<bool, _Temp<_GoToEventArgs>>(
            _coordinatorBloc.states.isAuthenticated.startWith(false),
            (args, isLoggedIn) => _Temp<_GoToEventArgs>(
              args: args,
              isLoggedIn: isLoggedIn,
              ))
        .flatMap(
          (value) => _routePermissions
              .execute(
                  isLoggedIn: value.isLoggedIn,
                  routePath: value.args.route.routeLocation)
                      .then((_) => value.args)
                      .asResultStream(),
        )
        .setErrorStateHandler(this)
        .whereSuccess()
        .map((args) =>
            _router.go(args.route.routeLocation, extra: args.extra)),
      _$pushToEvent.throttleTime(const Duration(seconds: 1)).map(
        (args) =>
            _router.push(args.route.routeLocation, extra: args.extra),
        ),
  ]).publish();
}

  class _Temp<T> {
    _Temp({
      required this.args,
      required this.isLoggedIn,
    });

    final T args;
    final bool isLoggedIn;
  }

// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:go_router/go_router.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../models/route_data_model.dart';

part 'router_bloc.rxb.g.dart';

/// A contract class containing all events of the NavigationBloC.
abstract class RouterBlocEvents {
  void goTo(RouteDataModel route, {Object? extra});

  void goToLocation(String location);

  void pushTo(RouteDataModel route, {Object? extra});
}

/// A contract class containing all states of the NavigationBloC.
abstract class RouterBlocStates {
  /// The error state
  Stream<String> get errors;

  ConnectableStream<void> get navigationPath;
}

@RxBloc()
class RouterBloc extends $RouterBloc {
  RouterBloc({
    required GoRouter router,
  }) : _router = router {
    navigationPath.connect().addTo(_compositeSubscription);
  }

  final GoRouter _router;

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((error) => error.toString()).share();

  @override
  ConnectableStream<void> _mapToNavigationPathState() => Rx.merge([
        _$goToLocationEvent.doOnData(_router.go).asResultStream(),
        _$goToEvent.doOnData(_go).asResultStream(),
        _$pushToEvent.doOnData(_push).asResultStream(),
      ]).setErrorStateHandler(this).whereSuccess().publish();

  Future<void> _go(_GoToEventArgs routeData) async =>
      _router.go(routeData.route.routeLocation, extra: routeData.extra);

  Future<void> _push(_PushToEventArgs routeData) async =>
      _router.push(routeData.route.routeLocation, extra: routeData.extra);
}

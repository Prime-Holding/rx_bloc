// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_extensions.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../models/route_data_model.dart';
import '../router.dart';

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
  Stream<ErrorModel> get errors;

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
  Stream<ErrorModel> _mapToErrorsState() =>
      errorState.mapToErrorModel().share();

  @override
  ConnectableStream<void> _mapToNavigationPathState() => Rx.merge([
        _$goToEvent
            .throttleTime(const Duration(seconds: 1))
            .switchMap((routeData) => _go(routeData).asResultStream()),
        _$pushToEvent
            .throttleTime(const Duration(seconds: 1))
            .switchMap((routeData) => _push(routeData).asResultStream()),
        _$goToLocationEvent.doOnData(_router.go).asResultStream(),
      ]).setErrorStateHandler(this).whereSuccess().publish();

  Future<void> _go(_GoToEventArgs routeData) async =>
      _router.go(routeData.route.routeLocation, extra: routeData.extra);

  Future<void> _push(_PushToEventArgs routeData) async =>
      _router.push(routeData.route.routeLocation, extra: routeData.extra);
}

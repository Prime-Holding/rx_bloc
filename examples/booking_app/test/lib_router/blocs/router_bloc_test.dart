import 'package:booking_app/lib_router/blocs/router_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../stubs.dart';

@GenerateMocks([
  GoRouter,
])
void main() {
  RouterBloc routerBloc() => RouterBloc(router: GoRouter(routes: []));

  group('test router_bloc state navigationPath', () {
    rxBlocTest(
      'test router_bloc state navigationPath goToLocation',
      build: () async => routerBloc(),
      act: (bloc) async => bloc.events.goToLocation('/'),
      state: (bloc) => bloc.states.navigationPath,
      expect: [],
    );

    rxBlocTest(
      'test router_bloc state navigationPath go',
      build: () async => routerBloc(),
      act: (bloc) async => bloc.events.goTo(Stub.homePageRoute),
      state: (bloc) => bloc.states.navigationPath,
      expect: [],
    );
  });
}

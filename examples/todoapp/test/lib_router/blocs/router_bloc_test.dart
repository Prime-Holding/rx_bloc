import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/lib_permissions/services/permissions_service.dart';
import 'package:todoapp/lib_router/blocs/router_bloc.dart';
import 'package:todoapp/lib_router/router.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../stubs.dart';
import 'router_bloc_test.mocks.dart';

@GenerateMocks([
  AppRouter,
  PermissionsService,
])
void main() {
  late CoordinatorBlocType coordinatorBloc;
  late CoordinatorStates coordinatorStates;
  late PermissionsService permissionsService;

  void defineWhen({bool shouldThrowError = false}) {
    when(coordinatorStates.isAuthenticated).thenAnswer(
        (_) => shouldThrowError ? Stream.error(Error()) : Stream.value(true));
  }

  setUp(() {
    coordinatorStates = coordinatorStatesMockFactory();
    coordinatorBloc = coordinatorBlocMockFactory(states: coordinatorStates);
    permissionsService = MockPermissionsService();
  });

  RouterBloc routerBloc() => RouterBloc(
      router: AppRouter(coordinatorBloc: coordinatorBloc).router,
      permissionsService: permissionsService);

  group('test router_bloc state navigationPath', () {
    rxBlocTest(
      'test router_bloc state navigationPath goToLocation',
      build: () async {
        defineWhen();
        return routerBloc();
      },
      act: (bloc) async => bloc.events.goToLocation('/'),
      state: (bloc) => bloc.states.navigationPath,
      expect: [isA<void>()],
    );

    rxBlocTest(
      'test router_bloc state navigationPath push',
      build: () async {
        defineWhen();
        return routerBloc();
      },
      act: (bloc) async => bloc.events.push(Stubs.homePageRoute),
      state: (bloc) => bloc.states.navigationPath,
      expect: [],
    );

    rxBlocTest(
      'test router_bloc state navigationPath pop',
      build: () async {
        defineWhen();
        return routerBloc();
      },
      act: (bloc) async => bloc.events.pop(),
      state: (bloc) => bloc.states.navigationPath,
      expect: [isA<void>()],
    );

    rxBlocTest(
      'test router_bloc state navigationPath pushReplace',
      build: () async {
        defineWhen();
        return routerBloc();
      },
      act: (bloc) async => bloc.events.pushReplace(Stubs.homePageRoute),
      state: (bloc) => bloc.states.navigationPath,
      expect: [],
    );

    rxBlocTest(
      'test router_bloc state navigationPath go',
      build: () async {
        defineWhen();
        return routerBloc();
      },
      act: (bloc) async => bloc.events.go(Stubs.homePageRoute),
      state: (bloc) => bloc.states.navigationPath,
      expect: [],
    );
  });
}

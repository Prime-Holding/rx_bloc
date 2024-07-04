import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:todoapp/base/common_blocs/coordinator_bloc.dart';
import 'package:todoapp/base/common_mappers/error_mappers/error_mapper.dart';
import 'package:todoapp/lib_permissions/data_sources/remote/permissions_remote_data_source.dart';
import 'package:todoapp/lib_permissions/repositories/permissions_repository.dart';
import 'package:todoapp/lib_permissions/services/permissions_service.dart';
import 'package:todoapp/lib_router/blocs/router_bloc.dart';
import 'package:todoapp/lib_router/router.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../stubs.dart';

@GenerateMocks([
  AppRouter,
])
void main() {
  late CoordinatorBlocType _coordinatorBloc;
  late CoordinatorStates _coordinatorStates;

  void _defineWhen() {
    when(_coordinatorStates.isAuthenticated)
        .thenAnswer((_) => Stream.value(true));
  }

  setUp(() {
    _coordinatorStates = coordinatorStatesMockFactory();
    _coordinatorBloc = coordinatorBlocMockFactory(states: _coordinatorStates);
  });

  RouterBloc routerBloc() => RouterBloc(
      router: AppRouter(coordinatorBloc: _coordinatorBloc).router,
      permissionsService: PermissionsService(PermissionsRepository(
          ErrorMapper(_coordinatorBloc), PermissionsRemoteDataSource(Dio()))));

  group('test router_bloc state navigationPath', () {
    rxBlocTest(
      'test router_bloc state navigationPath goToLocation',
      build: () async {
        _defineWhen();
        return routerBloc();
      },
      act: (bloc) async => bloc.events.goToLocation('/'),
      state: (bloc) => bloc.states.navigationPath,
      expect: [],
    );

    rxBlocTest(
      'test router_bloc state navigationPath go',
      build: () async {
        _defineWhen();
        return routerBloc();
      },
      act: (bloc) async => bloc.events.go(Stubs.homePageRoute),
      state: (bloc) => bloc.states.navigationPath,
      expect: [],
    );
  });
}

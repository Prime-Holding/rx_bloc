import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/lib_router/blocs/router_bloc.dart';

import 'router_bloc_mock.mocks.dart';

@GenerateMocks([
  RouterBlocEvents,
  RouterBlocStates,
  RouterBlocType,
])
RouterBlocType routerBlocMockFactory() {
  final routerBloc = MockRouterBlocType();
  final eventsMock = MockRouterBlocEvents();
  final statesMock = MockRouterBlocStates();

  when(routerBloc.events).thenReturn(eventsMock);
  when(routerBloc.states).thenReturn(statesMock);

  when(statesMock.errors)
      .thenAnswer((_) => const Stream<ErrorModel>.empty().publish());

  return routerBloc;
}

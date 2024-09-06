import 'package:booking_app/lib_router/blocs/router_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'router_bloc_mock.mocks.dart';

@GenerateMocks([
  RouterBlocStates,
  RouterBlocEvents,
  RouterBlocType,
])
RouterBlocType routerMockFactory({
  Function()? onPushTo,
}) {
  final blocMock = MockRouterBlocType();
  final eventsMock = MockRouterBlocEvents();
  final statesMock = MockRouterBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  if (onPushTo != null) {
    when(eventsMock.pushTo(any, extra: anyNamed('extra'))).thenAnswer((_) {
      onPushTo();
    });
  }

  return blocMock;
}

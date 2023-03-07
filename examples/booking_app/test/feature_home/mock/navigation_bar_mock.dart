import 'package:booking_app/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../stubs.dart';
import 'navigation_bar_mock.mocks.dart';

@GenerateMocks([
  NavigationBarBlocStates,
  NavigationBarBlocEvents,
  NavigationBarBlocType,
])
NavigationBarBlocType navigationBarMock({
  required NavigationItemType navigationType,
}) {
  final blocMock = MockNavigationBarBlocType();
  final eventsMock = MockNavigationBarBlocEvents();
  final statesMock = MockNavigationBarBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  when(statesMock.selectedItem)
      .thenAnswer((_) => Stream.value(Stub.navBarSelectedItem));

  when(statesMock.items).thenAnswer((_) => Stream.value(Stub.navBarItemsList));

  return blocMock;
}

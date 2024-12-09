import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reminders/feature_splash/blocs/splash_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'splash_mock.mocks.dart';

@GenerateMocks([SplashBlocStates, SplashBlocEvents, SplashBlocType])
SplashBlocType splashMockFactory({
  required bool isLoading,
  String? errors,
}) {
  final blocMock = MockSplashBlocType();
  final eventsMock = MockSplashBlocEvents();
  final statesMock = MockSplashBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final isLoadingState = Stream.value(isLoading).shareReplay(maxSize: 1);

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<String?>.empty();

  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.errors).thenAnswer((_) => errorsState);

  return blocMock;
}

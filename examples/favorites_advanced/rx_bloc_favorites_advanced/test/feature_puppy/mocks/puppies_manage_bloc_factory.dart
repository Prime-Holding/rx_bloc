import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/blocs/puppy_manage_bloc.dart';

import 'puppies_manage_bloc_factory.mocks.dart';

@GenerateMocks([
  PuppyManageEvents,
  PuppyManageStates,
  PuppyManageBloc,
])
PuppyManageBloc puppiesManageBlocFactory() {
  final bloc = MockPuppyManageBloc();
  final events = MockPuppyManageEvents();
  final states = MockPuppyManageStates();

  when(bloc.events).thenReturn(events);
  when(bloc.states).thenReturn(states);

  return bloc;
}

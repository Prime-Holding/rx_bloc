import 'dart:async';

import 'package:favorites_advanced_base/repositories.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/blocs/puppies_extra_details_bloc.dart';
import 'package:test/test.dart';

import '../../stubs.dart';
import 'puppies_extra_details_bloc_test.mocks.dart';

@GenerateMocks([
  CoordinatorEvents,
  CoordinatorStates,
  CoordinatorBlocType,
  PuppiesRepository,
])
void main() {
  late MockCoordinatorBlocType coordinatorMock;
  late MockCoordinatorStates mockCoordinatorStates;
  late MockCoordinatorEvents mockCoordinatorEvents;

  late MockPuppiesRepository repositoryMock;
  late PuppiesExtraDetailsBloc bloc;

  setUp(() {
    coordinatorMock = MockCoordinatorBlocType();
    mockCoordinatorStates = MockCoordinatorStates();
    mockCoordinatorEvents = MockCoordinatorEvents();

    when(coordinatorMock.states).thenReturn(mockCoordinatorStates);
    when(coordinatorMock.events).thenReturn(mockCoordinatorEvents);

    repositoryMock = MockPuppiesRepository();
    bloc = PuppiesExtraDetailsBloc(coordinatorMock, repositoryMock);
  });

  group('PuppiesExtraDetailsBloc', () {
    test('PuppiesExtraDetailsBloc -> CoordinatorBlocType integration ',
        () async {
      // Arrange: Setup mocks
      when(repositoryMock.fetchFullEntities(['1', '2']))
          .thenAnswer((_) async => Stub.puppies1And2WithExtraDetails);

      // Fetch puppies 1 and 2
      bloc.events.fetchExtraDetails(Stub.puppy1);
      bloc.events.fetchExtraDetails(Stub.puppy2);
      // Pre-verify: Wait longer than the buffer time
      await Future.delayed(const Duration(milliseconds: 110));

      /// Verify: Make sure `puppiesWithExtraDetailsFetched` have collected
      /// puppies one and two with their extra details
      verify(
        mockCoordinatorEvents
            .puppiesWithExtraDetailsFetched(Stub.puppies1And2WithExtraDetails),
      ).called(1);
    });
  });
}

import 'dart:async';

import 'package:favorites_advanced_base/repositories.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/blocs/puppies_extra_details_bloc.dart';
import 'package:test/test.dart';

import '../../mocks.dart';
import '../../stubs.dart';

void main() {
  late CoordinatorBlocType mockCoordinator;
  late PuppiesRepository repositoryMock;
  late PuppiesExtraDetailsBloc bloc;

  setUp(() {
    mockCoordinator = CoordinatorBlocMock();
    repositoryMock = PuppiesRepositoryMock();
    bloc = PuppiesExtraDetailsBloc(mockCoordinator, repositoryMock);
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
        mockCoordinator.events
            .puppiesWithExtraDetailsFetched(Stub.puppies1And2WithExtraDetails),
      ).called(1);
    });
  });
}

import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:bloc_sample/feature_puppy/blocs/puppies_extra_details_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as mock;
import 'package:favorites_advanced_base/repositories.dart';

import '../../stubs.dart';
import 'puppies_extra_details_bloc_test.mocks.dart';


@GenerateMocks([
  PuppiesRepository,
  CoordinatorBloc,
])
void main() {
  late MockPuppiesRepository mockRepo;
  late MockCoordinatorBloc mockCoordinatorBloc;
  late PuppiesExtraDetailsBloc puppiesExtraDetailsBloc;

  setUp(() {
    mockRepo = MockPuppiesRepository();
    mockCoordinatorBloc = MockCoordinatorBloc();
    puppiesExtraDetailsBloc = PuppiesExtraDetailsBloc(
      repository: mockRepo,
      coordinatorBloc: mockCoordinatorBloc,
    );
  });

  blocTest<PuppiesExtraDetailsBloc, PuppiesExtraDetailsState>(
    'PuppiesExtraDetailsBloc blocTest',
    build: () {
      // Arrange: Setup mocks
      mock.when(mockRepo.fetchFullEntities(['1', '2']))
          .thenAnswer((_) async => Stub.puppies1And2WithExtraDetails);
      return puppiesExtraDetailsBloc;
    },
    act: (bloc) async {
      bloc
        ..add(FetchPuppyExtraDetailsEvent(Stub.puppy1))
        ..add(FetchPuppyExtraDetailsEvent(Stub.puppy2));
    },
    verify: (_) {
      // Verify: Make sure `CoordinatorPuppiesWithExtraDetailsEvent` have
      // collected puppies one and two with their extra details
      mock.verify(
        mockCoordinatorBloc.add(
          CoordinatorPuppiesWithExtraDetailsEvent(
              Stub.puppies1And2WithExtraDetails),
        ),
      ).called(1);
    },
  );
}

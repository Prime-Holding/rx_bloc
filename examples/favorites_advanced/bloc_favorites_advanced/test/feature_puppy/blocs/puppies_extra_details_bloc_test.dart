import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:bloc_sample/feature_puppy/blocs/puppies_extra_details_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:favorites_advanced_base/repositories.dart';

import '../../stubs.dart';
import 'puppies_extra_details_bloc_test.mocks.dart';

// class MockPuppiesRepository extends Mock implements PuppiesRepository {}

// class MockCoordinatorBloc extends Mock implements CoordinatorBloc {}

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

  // test('PuppiesExtraDetailsBloc ', () async {
  //   // Arrange: Setup mocks
  //   when(mockRepo.fetchFullEntities(['1', '2']))
  //       .thenAnswer((_) async => Stub.puppies1And2WithExtraDetails);
  //
  //   // Fetch puppies 1 and 2
  //   puppiesExtraDetailsBloc
  //     ..add(FetchPuppyExtraDetailsEvent(Stub.puppy1))
  //     ..add(FetchPuppyExtraDetailsEvent(Stub.puppy2));
  //
  //   // Pre-verify: Wait longer than the buffer time
  //   await Future.delayed(const Duration(milliseconds: 110));
  //
  //   verify(
  //     mockCoordinatorBloc.add(
  //       CoordinatorPuppiesWithExtraDetailsEvent(
  //           Stub.puppies1And2WithExtraDetails),
  //     ),
  //   ).called(1);
  // });

  blocTest<PuppiesExtraDetailsBloc, PuppiesExtraDetailsState>(
    'PuppiesExtraDetailsBloc blocTest',
    build: () {
      // Arrange: Setup mocks
      when(mockRepo.fetchFullEntities(['1', '2']))
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
      verify(
        mockCoordinatorBloc.add(
          CoordinatorPuppiesWithExtraDetailsEvent(
              Stub.puppies1And2WithExtraDetails),
        ),
      ).called(1);
    },
  );
}

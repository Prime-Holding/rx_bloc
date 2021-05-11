import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:bloc_sample/feature_puppy/blocs/puppy_manage_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:mockito/mockito.dart';

import '../../stubs.dart';
import 'puppy_manage_bloc_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
  CoordinatorBloc,
])
void main() {
  late MockPuppiesRepository mockRepo;
  late MockCoordinatorBloc mockCoordinatorBloc;
  late PuppyManageBloc puppyManageBloc;

  setUp(() {
    mockRepo = MockPuppiesRepository();
    mockCoordinatorBloc = MockCoordinatorBloc();
    when(mockCoordinatorBloc.stream).thenAnswer((_) => const Stream.empty());
    puppyManageBloc = PuppyManageBloc(
      puppiesRepository: mockRepo,
      coordinatorBloc: mockCoordinatorBloc,
    );
  });

  blocTest<PuppyManageBloc, PuppyManageState>(
    'PuppyManageBloc PuppyManageEvent',
    build: () {
      when(mockRepo.favoritePuppy(Stub.isNotFavoritePuppy3, isFavorite: true))
          .thenAnswer((_) async => Stub.isFavoritePuppy3);
      return puppyManageBloc;
    },
    act: (bloc) {
      bloc.add(PuppyManageMarkAsFavoriteEvent(
        puppy: Stub.isNotFavoritePuppy3,
        isFavorite: true,
      ));
    },
    verify: (_) {
      mockCoordinatorBloc
        ..add(
          CoordinatorPuppyUpdatedEvent(Stub.isFavoritePuppy3),
        )
        ..add(
          CoordinatorFavoritePuppyUpdatedEvent(
            favoritePuppy: Stub.isFavoritePuppy3,
            updateException: '',
          ),
        );
    },
  );

  blocTest<PuppyManageBloc, PuppyManageState>(
    'PuppyManageBloc PuppyManageEvent throws exception',
    build: () {
      when(mockRepo.favoritePuppy(Stub.isNotFavoritePuppy3, isFavorite: true))
          .thenThrow(Stub.testErr);
      return puppyManageBloc;
    },
    act: (bloc) {
      bloc.add(PuppyManageMarkAsFavoriteEvent(
        puppy: Stub.isNotFavoritePuppy3,
        isFavorite: true,
      ));
    },
    expect: () => <PuppyManageState>[
      puppyManageBloc.state.copyWith(error: Stub.testErrString),
      // const PuppyManageState(puppy: null,error: Stub.testErrString),
    ],
    verify: (_) {
      mockCoordinatorBloc
        ..add(
          CoordinatorPuppyUpdatedEvent(Stub.isFavoritePuppy3),
        )
        ..add(CoordinatorPuppyUpdatedEvent(
          Stub.isNotFavoritePuppy3,
        ))
        ..add(CoordinatorFavoritePuppyUpdatedEvent(
          favoritePuppy: Stub.isNotFavoritePuppy3,
          updateException: Stub.testErrString,
        ));
    },
  );
}

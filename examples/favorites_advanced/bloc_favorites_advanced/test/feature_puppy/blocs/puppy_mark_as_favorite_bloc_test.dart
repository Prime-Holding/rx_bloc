import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:bloc_sample/feature_puppy/blocs/puppy_mark_as_favorite_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:mockito/mockito.dart' as mock;

import '../../stubs.dart';
import 'puppy_mark_as_favorite_bloc_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
  CoordinatorBloc,
])
void main() {
  late MockPuppiesRepository mockRepo;
  late MockCoordinatorBloc mockCoordinatorBloc;
  late PuppyMarkAsFavoriteBloc puppyManageBloc;

  setUp(() {
    mockRepo = MockPuppiesRepository();
    mockCoordinatorBloc = MockCoordinatorBloc();
    mock
        .when(mockCoordinatorBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    puppyManageBloc = PuppyMarkAsFavoriteBloc(
      puppiesRepository: mockRepo,
      coordinatorBloc: mockCoordinatorBloc,
    );
  });

  blocTest<PuppyMarkAsFavoriteBloc, PuppyMarkAsFavoriteState>(
    'PuppyManageBloc PuppyManageEvent',
    build: () {
      mock
          .when(mockRepo.favoritePuppy(Stub.isNotFavoritePuppy3,
              isFavorite: true))
          .thenAnswer((_) async => Stub.isFavoritePuppy3);
      return puppyManageBloc;
    },
    act: (bloc) {
      bloc.add(PuppyMarkAsFavoriteEvent(
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

  blocTest<PuppyMarkAsFavoriteBloc, PuppyMarkAsFavoriteState>(
    'PuppyManageBloc PuppyManageEvent throws exception',
    build: () {
      mock
          .when(mockRepo.favoritePuppy(Stub.isNotFavoritePuppy3,
              isFavorite: true))
          .thenThrow(Stub.testErr);
      return puppyManageBloc;
    },
    act: (bloc) async {
      bloc.add(PuppyMarkAsFavoriteEvent(
        puppy: Stub.isNotFavoritePuppy3,
        isFavorite: true,
      ));
    },
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

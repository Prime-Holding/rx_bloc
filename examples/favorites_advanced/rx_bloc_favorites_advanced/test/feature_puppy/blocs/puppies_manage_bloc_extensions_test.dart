import 'package:favorites_advanced_base/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart';
import 'package:rx_bloc_favorites_advanced/base/repositories/paginated_puppies_repository.dart';

import 'package:rx_bloc_favorites_advanced/feature_puppy/blocs/puppy_manage_bloc.dart';

import 'package:rxdart/rxdart.dart';
import '../../stubs.dart';
import 'puppies_manage_bloc_extensions_test.mocks.dart';

@GenerateMocks([
  PaginatedPuppiesRepository,
])
void main() {
  group('markPuppyAsFavorite', () {
    test('Updates puppy as favorite and emits updated puppy and original puppy',
        () async {
      final mockRepository = MockPaginatedPuppiesRepository();
      final coordinatorBloc = CoordinatorBloc();
      final mockBloc = PuppyManageBloc(
        mockRepository,
        coordinatorBloc,
      );
      final errorSubject = PublishSubject<Exception>();

      final puppy = Stub.puppy1;
      final updatedPuppy = puppy.copyWith(isFavorite: true);

      final argsStream = Stream<({Puppy puppy, bool isFavorite})>.fromIterable([
        (puppy: puppy, isFavorite: true),
      ]);

      when(mockRepository.favoritePuppy(any,
              isFavorite: anyNamed('isFavorite')))
          .thenAnswer((_) async => updatedPuppy);

      final resultStream = argsStream.markPuppyAsFavorite(
          mockRepository, mockBloc, errorSubject);

      await expectLater(
        resultStream,
        emitsInOrder([
          updatedPuppy,
          updatedPuppy,
        ]),
      );

      await errorSubject.close();
    });

    test('Emits updated puppy and original puppy in case of error', () async {
      final mockRepository = MockPaginatedPuppiesRepository();
      final coordinatorBloc = CoordinatorBloc();
      final mockBloc = PuppyManageBloc(
        mockRepository,
        coordinatorBloc,
      );
      final errorSubject = PublishSubject<Exception>();
      final puppy = Stub.puppy1;
      final updatedPuppy = puppy.copyWith(isFavorite: true);
      final exception = Exception('Failed to update puppy');

      when(mockRepository.favoritePuppy(puppy,
              isFavorite: anyNamed('isFavorite')))
          .thenThrow(exception);

      final argsStream = Stream<({Puppy puppy, bool isFavorite})>.fromIterable([
        (puppy: puppy, isFavorite: true),
      ]);

      final resultStream = argsStream.markPuppyAsFavorite(
          mockRepository, mockBloc, errorSubject);

      await expectLater(
        resultStream,
        emitsInOrder([
          updatedPuppy,
          puppy,
        ]),
      );
    });
  });
}

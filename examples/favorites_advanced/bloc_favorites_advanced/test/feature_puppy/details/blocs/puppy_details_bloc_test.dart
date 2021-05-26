import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:bloc_sample/feature_puppy/details/blocs/puppy_details_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as mock;

import '../../../stubs.dart';
import 'puppy_details_bloc_test.mocks.dart';

@GenerateMocks([
  CoordinatorBloc,
])
void main() {
  late MockCoordinatorBloc mockCoordinatorBloc;
  late PuppyDetailsBloc puppyDetailsBloc;

  setUp(() {
    mockCoordinatorBloc = MockCoordinatorBloc();
    mock.when(mockCoordinatorBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    puppyDetailsBloc = PuppyDetailsBloc(
      coordinatorBloc: mockCoordinatorBloc,
      puppy: Stub.isNotFavoritePuppy3,
    );
  });

  // test('PuppyDetailsBloc PuppyDetailsEvent', () async {
  //   puppyDetailsBloc.add(PuppyDetailsEvent(
  //     puppy: Stub.isNotFavoritePuppy3,
  //     updateException: '',
  //   ));
  //
  // });
  blocTest<PuppyDetailsBloc, PuppyDetailsState>(
      'PuppyDetailsBloc PuppyDetailsEvent',
      build: () => puppyDetailsBloc,
      act: (bloc) {
        bloc.add(PuppyDetailsEvent(
          puppy: Stub.isNotFavoritePuppy3,
          updateException: '',
        ));
      },
      expect: () => <PuppyDetailsState>[
            puppyDetailsBloc.state.copyWith(puppy: Stub.isNotFavoritePuppy3),
          ]);



  blocTest<PuppyDetailsBloc, PuppyDetailsState>(
      'PuppyDetailsBloc PuppyDetailsEvent with exception',
      build: () => puppyDetailsBloc,
      act: (bloc) {
        bloc.add(PuppyDetailsEvent(
          puppy: Stub.isNotFavoritePuppy3,
          updateException: Stub.testErrString,
        ));
      },
      expect: () => <PuppyDetailsState>[
            puppyDetailsBloc.state.copyWith(puppy: Stub.isFavoritePuppy3),
            puppyDetailsBloc.state.copyWith(puppy: Stub.isNotFavoritePuppy3),
          ]);
}

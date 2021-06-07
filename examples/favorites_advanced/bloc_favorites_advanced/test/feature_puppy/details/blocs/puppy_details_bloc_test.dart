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
// setUpAll(body);
  setUp(() {
    mockCoordinatorBloc = MockCoordinatorBloc();
    mock
        .when(mockCoordinatorBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    puppyDetailsBloc = PuppyDetailsBloc(
      coordinatorBloc: mockCoordinatorBloc,
      puppy: Stub.isNotFavoritePuppy3,
    );
  });

  blocTest<PuppyDetailsBloc, PuppyDetailsState>(
    'PuppyDetailsBloc PuppyDetailsFavoriteEvent',
    build: () => PuppyDetailsBloc(
      coordinatorBloc: mockCoordinatorBloc,
      puppy: Stub.isNotFavoritePuppy3,
    ),
    wait: const Duration(milliseconds: 400),
    act: (bloc) async {
      bloc.add(PuppyDetailsFavoriteEvent(
        puppy: Stub.isNotFavoritePuppy3,
        updateException: '',
      ));
      // await Future.delayed(const Duration(milliseconds: 200));
    },
    expect: () =>  <PuppyDetailsState>[
      // puppyDetailsBloc.state.copyWith(puppy: Stub.isNotFavoritePuppy3),
      PuppyDetailsState(puppy: Stub.isNotFavoritePuppy3),
    ],
  );

  blocTest<PuppyDetailsBloc, PuppyDetailsState>(
    'PuppyDetailsBloc PuppyDetailsFavoriteEvent with exception',
    build: () => puppyDetailsBloc,
    act: (bloc) async {
      bloc.add(PuppyDetailsFavoriteEvent(
        puppy: Stub.isNotFavoritePuppy3,
        updateException: Stub.testErrString,
      ));
      // await Future.delayed(const Duration(milliseconds: 200));
    },
    wait: const Duration(milliseconds: 400),
    expect: () => <PuppyDetailsState>[
      // puppyDetailsBloc.state.copyWith(puppy: Stub.isNotFavoritePuppy3),
      PuppyDetailsState(puppy: Stub.isNotFavoritePuppy3),
      // puppyDetailsBloc.state.copyWith(puppy: Stub.isNotFavoritePuppy3),
    ],
  );

  blocTest<PuppyDetailsBloc, PuppyDetailsState>(
    'PuppyDetailsBloc PuppyDetailsMarkAsFavoriteEvent',
    build: () => PuppyDetailsBloc(
      coordinatorBloc: mockCoordinatorBloc,
      puppy: Stub.isNotFavoritePuppy3,
    ),
    act: (bloc) async {
      bloc.add(PuppyDetailsMarkAsFavoriteEvent(
        puppies: Stub.onePuppyWithDetailsList,
      ));
    },
    wait: const Duration(milliseconds: 400),
    expect: () => <PuppyDetailsState>[
      PuppyDetailsState(puppy: Stub.onePuppyWithDetailsList[0]),
    ],
  );

}

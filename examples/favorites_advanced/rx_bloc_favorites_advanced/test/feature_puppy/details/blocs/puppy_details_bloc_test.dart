import 'package:favorites_advanced_base/models.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/details/blocs/puppy_details_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:test/test.dart';

import '../../../mocks.dart';
import '../../../stubs.dart';

void main() {
  late CoordinatorBlocType coordinatorMock;

  setUp(() {
    coordinatorMock = CoordinatorBlocMock();
  });

  group('PuppyDetailsBloc update puppy', () {
    rxBlocTest<PuppyDetailsBloc, Puppy>(
      'PuppyDetailsBloc.puppy update puppy: '
      'success triggered by CoordinatorBloc.onPuppiesUpdated',
      build: () async {
        when(coordinatorMock.states.onPuppiesUpdated).thenAnswer((_) async* {
          yield [Stub.puppy2];
          yield [Stub.puppy1.copyWith(name: 'test')];
          yield [...Stub.puppies23, Stub.puppy1.copyWith(name: 'name')];
        });

        return PuppyDetailsBloc(coordinatorMock, puppy: Stub.puppy1);
      },
      state: (bloc) => bloc.states.puppy,
      expect: <Puppy>[
        Stub.puppy1,
        Stub.puppy1.copyWith(name: 'test'),
        Stub.puppy1.copyWith(name: 'name'),
      ],
    );

    rxBlocTest<PuppyDetailsBloc, String>(
      'PuppyDetailsBloc.puppy update puppy.name: '
      'success triggered by CoordinatorBloc.onPuppiesUpdated',
      build: () async {
        when(coordinatorMock.states.onPuppiesUpdated).thenAnswer((_) async* {
          yield [Stub.puppy2];
          yield [Stub.puppy1.copyWith(name: 'test')];
          yield [...Stub.puppies23, Stub.puppy1.copyWith(name: 'name')];
        });

        return PuppyDetailsBloc(coordinatorMock, puppy: Stub.puppy1);
      },
      state: (bloc) => bloc.states.name,
      expect: <String>[
        Stub.puppy1.name,
        'test',
        'name',
      ],
    );

    rxBlocTest<PuppyDetailsBloc, String?>(
      'PuppyDetailsBloc.breed update puppy.breed: '
      'success triggered by CoordinatorBloc.onPuppiesUpdated',
      build: () async {
        when(coordinatorMock.states.onPuppiesUpdated).thenAnswer((_) async* {
          yield Stub.puppiesWithDetails.sublist(0, 2);
          yield [
            ...Stub.puppiesWithDetails.sublist(0, 2),
            Stub.puppiesWithDetails[2].copyWith(breedType: BreedType.Akita),
          ];
        });

        return PuppyDetailsBloc(
          coordinatorMock,
          puppy: Stub.puppiesWithDetails[2],
        );
      },
      state: (bloc) => bloc.states.breed,
      expect: <String?>[
        Stub.puppiesWithDetails[2].breedTypeAsString,
        PuppyDataConversion.getBreedTypeString(BreedType.Akita),
      ],
    );

    rxBlocTest<PuppyDetailsBloc, String?>(
      'PuppyDetailsBloc.characteristics update puppy.characteristics: '
      'success triggered by CoordinatorBloc.onPuppiesUpdated',
      build: () async {
        when(coordinatorMock.states.onPuppiesUpdated).thenAnswer((_) async* {
          yield Stub.puppiesWithDetails.sublist(0, 2);
          yield [
            ...Stub.puppiesWithDetails.sublist(0, 2),
            Stub.puppiesWithDetails[2].copyWith(displayCharacteristics: 'test'),
          ];
        });

        return PuppyDetailsBloc(
          coordinatorMock,
          puppy: Stub.puppiesWithDetails[2],
        );
      },
      state: (bloc) => bloc.states.characteristics,
      expect: <String?>[
        Stub.puppiesWithDetails[2].displayCharacteristics,
        'test',
      ],
    );

    rxBlocTest<PuppyDetailsBloc, String>(
      'PuppyDetailsBloc.gender update puppy.gender: '
      'success triggered by CoordinatorBloc.onPuppiesUpdated',
      build: () async {
        when(coordinatorMock.states.onPuppiesUpdated).thenAnswer((_) async* {
          yield Stub.puppiesWithDetails.sublist(0, 2);
          yield [
            ...Stub.puppiesWithDetails.sublist(0, 2),
            Stub.puppiesWithDetails[2].copyWith(gender: Gender.Female),
          ];
        });

        return PuppyDetailsBloc(
          coordinatorMock,
          puppy: Stub.puppiesWithDetails[2],
        );
      },
      state: (bloc) => bloc.states.gender,
      expect: <String>[
        PuppyDataConversion.getGenderString(Gender.Male),
        PuppyDataConversion.getGenderString(Gender.Female),
      ],
    );

    rxBlocTest<PuppyDetailsBloc, String>(
      'PuppyDetailsBloc.imagePath update puppy.asset: '
      'success triggered by CoordinatorBloc.onPuppiesUpdated',
      build: () async {
        when(coordinatorMock.states.onPuppiesUpdated).thenAnswer((_) async* {
          yield Stub.puppiesWithDetails.sublist(0, 2);
          yield [
            ...Stub.puppiesWithDetails.sublist(0, 2),
            Stub.puppiesWithDetails[2].copyWith(asset: 'test'),
          ];
        });

        return PuppyDetailsBloc(
          coordinatorMock,
          puppy: Stub.puppiesWithDetails[2],
        );
      },
      state: (bloc) => bloc.states.imagePath,
      expect: <String>[
        Stub.puppiesWithDetails[2].asset,
        'test',
      ],
    );

    rxBlocTest<PuppyDetailsBloc, bool>(
      'PuppyDetailsBloc.isFavourite update puppy.isFavourite: '
      'success triggered by CoordinatorBloc.onPuppiesUpdated',
      build: () async {
        when(coordinatorMock.states.onPuppiesUpdated).thenAnswer((_) async* {
          yield Stub.puppiesWithDetails.sublist(0, 2);
          yield [
            ...Stub.puppiesWithDetails.sublist(0, 2),
            Stub.puppiesWithDetails[2].copyWith(isFavorite: true),
          ];
        });

        return PuppyDetailsBloc(
          coordinatorMock,
          puppy: Stub.puppiesWithDetails[2],
        );
      },
      state: (bloc) => bloc.states.isFavourite,
      expect: <bool>[
        false,
        true,
      ],
    );

    rxBlocTest<PuppyDetailsBloc, String>(
      'PuppyDetailsBloc.genderAndBreed update puppy.gender '
      'and puppy.characteristics: success triggered by '
      'CoordinatorBloc.onPuppiesUpdated',
      build: () async {
        when(coordinatorMock.states.onPuppiesUpdated).thenAnswer((_) async* {
          yield Stub.puppiesWithDetails.sublist(0, 2);
          yield [
            ...Stub.puppiesWithDetails.sublist(0, 2),
            Stub.puppiesWithDetails[2].copyWith(
              gender: Gender.Female,
              breedType: BreedType.Akita,
            ),
          ];
        });

        return PuppyDetailsBloc(
          coordinatorMock,
          puppy: Stub.puppiesWithDetails[2],
        );
      },
      state: (bloc) => bloc.states.genderAndBreed,
      expect: <String>[
        Stub.expectedGenderAndBreed0,
        Stub.expectedGenderAndBreed1,
      ],
    );
  });
}

import 'package:favorites_advanced_base/models.dart';
// import 'package:flutter_rx_bloc/rx_form.dart';

class Stub {
  static final navigation = NavigationStub();

  static final emptyPuppyList = <Puppy>[];

  static final puppy1 = Puppy(
    name: '1',
    asset: '1',
    id: '1',
    isFavorite: false,
  );

  static final puppy2 = Puppy(
    name: '2',
    asset: '2',
    id: '2',
    isFavorite: false,
  );

  static final puppy3 = Puppy(
    name: '3',
    asset: '3',
    id: '3',
    isFavorite: false,
  );

  static final puppyTest = Puppy(
    name: 'Test',
    asset: '2',
    id: '2',
    isFavorite: false,
  );

  static final puppyTestUpdated = Puppy(
    name: 'Test',
    asset: '2',
    id: '2',
    isFavorite: true,
  );

  static final puppies12 = [
    puppy1,
    puppy2,
  ];

  static final puppies23 = [
    puppy2,
    puppy3,
  ];

  static final puppies123 = [puppy1, puppy2, puppy3];
  static final puppies123Test = [puppy1, puppy2, puppy3, puppyTest];
  static final puppies123TestUpdated = [
    puppy1,
    puppy2,
    puppy3,
    puppyTestUpdated
  ];
  static final puppiesTest = [puppyTest];
  static final puppiesTestUpdated = [puppyTestUpdated];

  static const pickImageDelay = Duration(seconds: 2, milliseconds: 10);

  static final puppiesWithDetails = [
    Puppy(
      id: '0',
      name: 'Charlie',
      asset: 'puppie_1.jpeg',
      isFavorite: true,
      gender: Gender.Male,
      breedType: BreedType.GoldenRetriever,
      displayCharacteristics: 'start characteristics',
    ),
    Puppy(
      id: '1',
      name: 'Max',
      asset: 'puppie_2.jpeg',
      gender: Gender.Male,
      breedType: BreedType.Cavachon,
    ),
    Puppy(
      id: '2',
      name: 'Buddy',
      asset: 'puppie_3.jpeg',
      gender: Gender.Male,
      breedType: BreedType.GermanShepherd,
    ),
  ]
      .map((p) => p.copyWith(
          displayName: p.name,
          displayCharacteristics: 'chars ${p.id}',
          breedCharacteristics: 'chars ${p.id}'))
      .toList();

  static final string31 = ''.padRight(31, 'a');
  static final string251 = ''.padRight(251, 'a');
  //
  // static const nameEmptyErr = RxFieldException<String>(
  //   fieldValue: '',
  //   error: 'Name must not be empty.',
  // );
  //
  // static final nameTooLongErr = RxFieldException<String>(
  //   fieldValue: Stub.string31,
  //   error: 'Name too long.',
  // );
  //
  // static const characteristicsEmptyErr = RxFieldException<String>(
  //   fieldValue: '',
  //   error: 'Characteristics must not be empty.',
  // );
  //
  // static const characteristicsNullErr = RxFieldException<String?>(
  //   fieldValue: null,
  //   error: 'Characteristics must not be empty.',
  // );
  //
  // static final characteristicsTooLongErr = RxFieldException<String>(
  //   fieldValue: Stub.string251,
  //   error: 'Characteristics must not exceed 250 characters.',
  // );

  static final testErr = Exception('test error');

  static Stream<T> delayed<T>(T value, [int milliseconds = 100]) =>
      Future.delayed(Duration(milliseconds: milliseconds), () async => value)
          .asStream();

  static final puppies1And2WithExtraDetails = [
    puppy1.copyWith(breedCharacteristics: '1', displayName: '1'),
    puppy2.copyWith(breedCharacteristics: '2', displayName: '2')
  ];

  static final expectedGenderAndBreed0 =
      '${Stub.puppiesWithDetails[2].genderAsString}, '
      '${Stub.puppiesWithDetails[2].breedTypeAsString}';

  static final expectedGenderAndBreed1 =
      '${PuppyDataConversion.getGenderString(Gender.Female)}, '
      '${PuppyDataConversion.getBreedTypeString(BreedType.Akita)}';
}

class NavigationStub {
  final searchTitle = 'Search for Puppies';
  final favoritesTitle = 'Favorites Puppies';

  final searchSelected = const NavigationItem(
    isSelected: true,
    type: NavigationItemType.search,
  );

  final searchNotSelected = const NavigationItem(
    isSelected: false,
    type: NavigationItemType.search,
  );

  final favoritesSelected = const NavigationItem(
    isSelected: true,
    type: NavigationItemType.favorites,
  );

  final favoritesNotSelected = const NavigationItem(
    isSelected: false,
    type: NavigationItemType.favorites,
  );
}

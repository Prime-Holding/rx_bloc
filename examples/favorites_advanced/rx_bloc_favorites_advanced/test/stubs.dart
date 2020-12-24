import 'package:favorites_advanced_base/models.dart';

class Stub {
  static final navigation = NavigationStub();

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

  static Stream<T> delayed<T>(T value, [int milliseconds = 100]) =>
      Future.delayed(Duration(milliseconds: milliseconds), () async => value)
          .asStream();

  static final puppies1And2WithExtraDetails = [
    puppy1.copyWith(breedCharacteristics: '1', displayName: '1'),
    puppy2.copyWith(breedCharacteristics: '2', displayName: '2')
  ];
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

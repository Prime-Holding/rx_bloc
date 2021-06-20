import 'package:favorites_advanced_base/models.dart';
import 'package:redux_favorite_advanced_sample/base/models/app_state.dart';
import 'package:redux_favorite_advanced_sample/feature_home/models/navigation_state.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/details/models/details_state.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/edit/models/edit_state.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/favorites/models/favorite_list_state.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/models/puppy_list_state.dart';

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

  static final testErr = Exception('test error');

  static Stream<T> delayed<T>(T value, [int milliseconds = 100]) =>
      Future.delayed(Duration(milliseconds: milliseconds), () async => value)
          .asStream();

  static final puppies1And2WithExtraDetails = [
    puppy1.copyWith(breedCharacteristics: '1', displayName: '1'),
    puppy2.copyWith(breedCharacteristics: '2', displayName: '2')
  ];

  static final puppies123ExtraDetails = [
    puppy1.copyWith(displayName: puppy1.name, displayCharacteristics: '1'),
    puppy2.copyWith(displayName: puppy2.name, displayCharacteristics: '2'),
    puppy3.copyWith(displayName: puppy3.name, displayCharacteristics: '3'),
  ];

  static final expectedGenderAndBreed0 =
      '${Stub.puppiesWithDetails[2].genderAsString}, '
      '${Stub.puppiesWithDetails[2].breedTypeAsString}';

  static final expectedGenderAndBreed1 =
      '${PuppyDataConversion.getGenderString(Gender.Female)}, '
      '${PuppyDataConversion.getBreedTypeString(BreedType.Akita)}';
}

class AppStateStub {
  static AppState initialState = AppState(
    navigationState: const NavigationState(
      items: [
        NavigationItem(
          type: NavigationItemType.search,
          isSelected: true,
        ),
        NavigationItem(
          type: NavigationItemType.favorites,
          isSelected: false,
        ),
      ],
    ),
    puppyListState: const PuppyListState(
      isLoading: false,
      isError: false,
      searchQuery: '',
      puppies: [],
    ),
    favoriteListState: const FavoriteListState(
      puppies: [],
    ),
    detailsState: DetailsState(
      puppy: Puppy(asset: '', id: '', name: ''),
    ),
    editState: EditState(
      isSubmitAttempted: false,
      isLoading: false,
      isUpdated: false,
      puppy: Puppy(asset: '', id: '', name: ''),
      nameError: '',
      characteristicsError: '',
      error: '',
    ),
    favoriteCount: 0,
    error: '',
  );

  static final withPuppies123 = AppStateStub.initialState.copyWith(
    puppyListState: AppStateStub.initialState.puppyListState
        .copyWith(puppies: Stub.puppies123),
  );

  static final withPuppy1 = AppStateStub.initialState.copyWith(
    puppyListState: AppStateStub.initialState.puppyListState.copyWith(
      puppies: [Stub.puppy1],
    ),
  );

  static final withPuppy1Error = AppStateStub.withPuppy1.copyWith(
    detailsState: DetailsState(puppy: Stub.puppy1),
    error: Stub.testErr.toString(),
  );

  static final withPuppy1Favorited = AppStateStub.initialState.copyWith(
    puppyListState: AppStateStub.initialState.puppyListState.copyWith(
      puppies: [Stub.puppy1.copyWith(isFavorite: true)],
    ),
  );

  static final withPuppy1FavoritedAndListed =
      AppStateStub.withPuppy1Favorited.copyWith(
    favoriteListState: FavoriteListState(
      puppies: [Stub.puppy1.copyWith(isFavorite: true)],
    ),
    favoriteCount: 1,
  );
}

class NavigationStub {
  static const searchTitle = 'Search for Puppies';
  static const favoritesTitle = 'Favorites Puppies';

  static const searchSelected = NavigationItem(
    isSelected: true,
    type: NavigationItemType.search,
  );

  static const searchNotSelected = NavigationItem(
    isSelected: false,
    type: NavigationItemType.search,
  );

  static const favoritesSelected = NavigationItem(
    isSelected: true,
    type: NavigationItemType.favorites,
  );

  static const favoritesNotSelected = NavigationItem(
    isSelected: false,
    type: NavigationItemType.favorites,
  );
}

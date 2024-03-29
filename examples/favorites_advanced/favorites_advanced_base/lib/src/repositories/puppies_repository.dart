import 'dart:io';

import 'package:favorites_advanced_base/src/utils/enums.dart';
import 'package:image_picker/image_picker.dart';
import 'connectivity_repository.dart';

import '../models/puppy.dart';

part 'puppies_repository_extensions.dart';

class PuppiesRepository {
  PuppiesRepository(
    ImagePicker picker,
    ConnectivityRepository connectivityRepository, {
    int multiplier = 500,
  })  : _picker = picker,
        _connectivityRepository = connectivityRepository,
        _puppies = _generateEntities(
          multiplier: multiplier,
        );

  final _noInternetConnectionErrorString =
      'No internet connection. Please check your settings.';

  /// Simulate delays of the API http requests
  final _artificialDelay = Duration(milliseconds: 300);

  final ImagePicker _picker;
  final ConnectivityRepository _connectivityRepository;

  Future<List<Puppy>> getPuppies({String query = ''}) async {
    await Future.delayed(_artificialDelay + Duration(milliseconds: 100));

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    if (query == '') {
      return _puppies;
    }

    final copiedPuppies = [..._puppies];

    return copiedPuppies
        .where(
            (puppy) => puppy.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Puppy>> getFavoritePuppies() async {
    await Future.delayed(_artificialDelay);

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    return _puppies.where((puppy) => puppy.isFavorite).toList();
  }

  Future<Puppy> favoritePuppy(
    Puppy puppy, {
    required bool isFavorite,
  }) async {
    await Future.delayed(_artificialDelay);

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    final foundPuppy = _puppies.firstWhere(
      (item) => item.id == puppy.id,
    );

    foundPuppy.isFavorite = isFavorite;

    return foundPuppy;
  }

  Future<List<Puppy>> fetchFullEntities(List<String> ids) async {
    await Future.delayed(_artificialDelay);

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    final puppiesWithExtraData = _puppies
        .where((element) => ids.contains(element.id))
        .map((puppy) => puppy.copyWith(
              displayName: puppy.name,
              displayCharacteristics: puppy.breedCharacteristics,
            ))
        .toList();

    return puppiesWithExtraData;
  }

  Future<Puppy> updatePuppy(String puppyId, Puppy newValue) async {
    await Future.delayed(_artificialDelay + Duration(seconds: 1));

    if (!(await _connectivityRepository.isConnected())) {
      throw Exception(_noInternetConnectionErrorString);
    }

    var foundPuppy = _puppies.firstWhere((item) => item.id == puppyId);

    final foundPuppyIndex = _puppies.indexOf(foundPuppy);
    foundPuppy = newValue.copyWith(
      id: puppyId,
      displayName: newValue.displayName != null ? newValue.name : null,
      displayCharacteristics: newValue.displayCharacteristics != null
          ? newValue.breedCharacteristics
          : null,
    );

    _puppies[foundPuppyIndex] = foundPuppy;

    return foundPuppy;
  }

  Future<XFile?> pickPuppyImage(ImagePickerAction source) =>
      _picker.pickPicture(source: source);

  List<Puppy> _puppies;

  static List<Puppy> _generateEntities({required int multiplier}) =>
      List.generate(
              multiplier,
              (index) => [..._puppiesDB]
                  .map(
                    (puppy) => puppy.copyWith(
                      id: "$index-${puppy.id}",
                      isFavorite: false,
                    ),
                  )
                  .toList())
          .expand((element) => element)
          .toList()
          .asMap()
          .entries
          .map(
            (entry) =>
                entry.value.copyWith(name: "${entry.value.name} ${entry.key}"),
          )
          .toList();

  static final _puppiesDB = [
    Puppy(
      id: '0',
      name: 'Charlie',
      asset: 'assets/puppie_1.jpeg',
      isFavorite: true,
      gender: Gender.Male,
      breedType: BreedType.GoldenRetriever,
    ),
    Puppy(
      id: '1',
      name: 'Max',
      asset: 'assets/puppie_2.jpeg',
      gender: Gender.Male,
      breedType: BreedType.Cavachon,
    ),
    Puppy(
      id: '2',
      name: 'Buddy',
      asset: 'assets/puppie_3.jpeg',
      gender: Gender.Male,
      breedType: BreedType.GermanShepherd,
    ),
    Puppy(
      id: '3',
      name: 'Jerry',
      asset: 'assets/puppie_4.jpeg',
      gender: Gender.Male,
      breedType: BreedType.BerneseMountainDog,
    ),
    Puppy(
      id: '4',
      name: 'Oscar',
      asset: 'assets/puppie_5.jpeg',
      gender: Gender.Male,
      breedType: BreedType.AustralianShepherd,
    ),
    Puppy(
      id: '5',
      name: 'Milo',
      asset: 'assets/puppie_6.jpeg',
      gender: Gender.Male,
      breedType: BreedType.Labradoodle,
    ),
    Puppy(
      id: '6',
      name: 'Archie',
      asset: 'assets/puppie_7.jpeg',
      gender: Gender.Male,
      breedType: BreedType.Beagle,
    ),
    Puppy(
      id: '7',
      name: 'Ollie',
      asset: 'assets/puppie_8.jpeg',
      gender: Gender.Male,
      breedType: BreedType.CaneCorso,
    ),
    Puppy(
      id: '8',
      name: 'Toby',
      asset: 'assets/puppie_9.jpeg',
      gender: Gender.Male,
      breedType: BreedType.LabradorRetriever,
    ),
    Puppy(
      id: '9',
      name: 'Jack',
      asset: 'assets/puppie_10.jpeg',
      gender: Gender.Male,
      breedType: BreedType.Mixed,
    ),
    Puppy(
      id: '10',
      name: 'Teddy',
      asset: 'assets/puppie_11.jpeg',
      gender: Gender.Male,
      breedType: BreedType.Rottweiler,
    ),
    Puppy(
      id: '11',
      name: 'Bella',
      asset: 'assets/puppie_12.jpeg',
      gender: Gender.Female,
      breedType: BreedType.Beagle,
    ),
    Puppy(
      id: '12',
      name: 'Molly',
      asset: 'assets/puppie_13.jpeg',
      gender: Gender.Female,
      breedType: BreedType.LabradorRetriever,
    ),
    Puppy(
      id: '13',
      name: 'Coco',
      asset: 'assets/puppie_14.jpeg',
      gender: Gender.Female,
      breedType: BreedType.GoldenRetriever,
    ),
    Puppy(
      id: '14',
      name: 'Ruby',
      asset: 'assets/puppie_15.jpeg',
      gender: Gender.Female,
      breedType: BreedType.Labradoodle,
    ),
    Puppy(
      id: '15',
      name: 'Lucy',
      asset: 'assets/puppie_16.jpeg',
      gender: Gender.Female,
      breedType: BreedType.Havanese,
    ),
    Puppy(
      id: '16',
      name: 'Bailey',
      asset: 'assets/puppie_17.jpeg',
      gender: Gender.Male,
      breedType: BreedType.GermanShepherd,
    ),
    Puppy(
      id: '17',
      name: 'Daisy',
      asset: 'assets/puppie_18.jpeg',
      gender: Gender.Female,
      breedType: BreedType.Samoyed,
    ),
    Puppy(
      id: '18',
      name: 'Gosho',
      asset: 'assets/puppie_19.jpeg',
      gender: Gender.Male,
      breedType: BreedType.CarolinaDog,
    ),
    Puppy(
      id: '19',
      name: 'Rosie',
      asset: 'assets/puppie_20.jpeg',
      gender: Gender.Female,
      breedType: BreedType.Dachshund,
    )
  ];
}

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

import '../models/puppy.dart';

class PuppiesRepository {
  /// Simulate delays of the API http requests
  final artificialDelay = Duration(milliseconds: 300);

  /// Control how many time the 20 below will be multiplied.
  final generatedPuppiesMultiplier = 50;

  PuppiesRepository() {
    puppies = _generateListOfPuppies();
  }

  Future<List<Puppy>> getPuppies({String query = ''}) async {
    await Future.delayed(artificialDelay + Duration(milliseconds: 100));

    if ((await Connectivity().checkConnectivity()) == ConnectivityResult.none) {
      throw Exception('No internet connection. Please check your settings.');
    }

    if (query == '') {
      return puppies;
    }

    final coppiedPuppies = [...puppies];

    return coppiedPuppies
        .where(
            (puppy) => puppy.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Puppy>> getFavoritePuppies() async {
    await Future.delayed(artificialDelay);

    if ((await Connectivity().checkConnectivity()) == ConnectivityResult.none) {
      throw Exception('No internet connection. Please check your settings.');
    }

    return puppies.where((puppy) => puppy.isFavorite).toList();
  }

  Future<Puppy> favoritePuppy(
    Puppy puppy, {
    @required bool isFavorite,
  }) async {
    await Future.delayed(artificialDelay);

    if ((await Connectivity().checkConnectivity()) == ConnectivityResult.none) {
      throw Exception('No internet connection. Please check your settings.');
    }

    final foundPuppy = puppies.firstWhere(
      (item) => item.id == puppy.id,
      orElse: () => null,
    );

    foundPuppy?.isFavorite = isFavorite;

    return foundPuppy;
  }

  Future<List<Puppy>> fetchFullEntities(List<String> ids) async {
    await Future.delayed(artificialDelay);

    if ((await Connectivity().checkConnectivity()) == ConnectivityResult.none) {
      throw Exception('No internet connection. Please check your settings.');
    }

    final puppiesWithExtraData = puppies
        .where((element) => ids.contains(element.id))
        .map((puppy) => puppy.copyWith(
              displayName: puppy.name,
              displayBreedCharacteristics: puppy.breedCharacteristics,
            ))
        .toList();

    return puppiesWithExtraData;
  }

  List<Puppy> puppies;

  List<Puppy> _generateListOfPuppies() => List.generate(
          generatedPuppiesMultiplier,
          (index) => [..._puppies]
              .map((puppy) =>
                  puppy.copyWith(id: "$index-${puppy.id}", isFavorite: false))
              .toList())
      .expand((element) => element)
      .toList()
      .asMap()
      .entries
      .map((entry) =>
          entry.value.copyWith(name: "${entry.value.name} ${entry.key}"))
      .toList();

  final _puppies = [
    Puppy(
      id: '0',
      name: 'Charlie',
      asset: 'assets/puppie_1.jpeg',
      isFavorite: true,
    ),
    Puppy(
      id: '1',
      name: 'Max',
      asset: 'assets/puppie_2.jpeg',
    ),
    Puppy(
      id: '2',
      name: 'Buddy',
      asset: 'assets/puppie_3.jpeg',
    ),
    Puppy(
      id: '3',
      name: 'Jerry',
      asset: 'assets/puppie_4.jpeg',
    ),
    Puppy(
      id: '4',
      name: 'Oscar',
      asset: 'assets/puppie_5.jpeg',
    ),
    Puppy(
      id: '5',
      name: 'Milo',
      asset: 'assets/puppie_6.jpeg',
    ),
    Puppy(
      id: '6',
      name: 'Archie',
      asset: 'assets/puppie_7.jpeg',
    ),
    Puppy(
      id: '7',
      name: 'Ollie',
      asset: 'assets/puppie_8.jpeg',
    ),
    Puppy(
      id: '8',
      name: 'Toby',
      asset: 'assets/puppie_9.jpeg',
    ),
    Puppy(
      id: '9',
      name: 'Jack',
      asset: 'assets/puppie_10.jpeg',
    ),
    Puppy(
      id: '10',
      name: 'Teddy',
      asset: 'assets/puppie_11.jpeg',
    ),
    Puppy(
      id: '11',
      name: 'Bella',
      asset: 'assets/puppie_12.jpeg',
    ),
    Puppy(
      id: '12',
      name: 'Molly',
      asset: 'assets/puppie_13.jpeg',
    ),
    Puppy(
      id: '13',
      name: 'Coco',
      asset: 'assets/puppie_14.jpeg',
    ),
    Puppy(
      id: '14',
      name: 'Ruby',
      asset: 'assets/puppie_15.jpeg',
    ),
    Puppy(
      id: '15',
      name: 'Lucy',
      asset: 'assets/puppie_16.jpeg',
    ),
    Puppy(
      id: '16',
      name: 'Bailey',
      asset: 'assets/puppie_17.jpeg',
    ),
    Puppy(
      id: '17',
      name: 'Daisy',
      asset: 'assets/puppie_18.jpeg',
    ),
    Puppy(
      id: '18',
      name: 'Gosho',
      asset: 'assets/puppie_19.jpeg',
    ),
    Puppy(
      id: '19',
      name: 'Rosie',
      asset: 'assets/puppie_20.jpeg',
    )
  ];
}

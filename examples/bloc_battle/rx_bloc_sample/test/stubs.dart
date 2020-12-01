import 'package:bloc_battle_base/models.dart';

final puppy1 = Puppy(
  name: '1',
  asset: '1',
  id: '1',
  displayName: '1',
  isFavorite: false,
);

final puppiesWithExtraDetails = [
  puppy1.copyWith(displayBreedCharacteristics: '1', displayName: '1')
];

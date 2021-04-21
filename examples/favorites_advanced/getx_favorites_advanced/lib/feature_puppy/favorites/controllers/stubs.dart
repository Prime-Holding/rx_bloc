import 'package:favorites_advanced_base/models.dart';

class Stub {

  static final emptyPuppyList = <Puppy>[];

  static final puppy1 = Puppy(
    id: '17',
    name: 'Daisy',
    asset: 'assets/puppie_18.jpeg',
    gender: Gender.Female,
    breedType: BreedType.Samoyed,
  );

  static final puppy2 = Puppy(
    id: '18',
    name: 'Gosho',
    asset: 'assets/puppie_19.jpeg',
    gender: Gender.Male,
    breedType: BreedType.CarolinaDog,
  );

  static final puppy3 = Puppy(
    id: '19',
    name: 'Rosie',
    asset: 'assets/puppie_20.jpeg',
    gender: Gender.Female,
    breedType: BreedType.Dachshund,
  );

  static final puppies123 = [puppy1, puppy2, puppy3];

}

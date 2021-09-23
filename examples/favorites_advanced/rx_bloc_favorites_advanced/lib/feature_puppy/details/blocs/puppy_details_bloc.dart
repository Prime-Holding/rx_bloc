import 'package:collection/collection.dart' show IterableExtension;
import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/common_blocs/coordinator_bloc.dart';

part 'puppy_details_bloc.rxb.g.dart';
part 'puppy_details_bloc_extensions.dart';

abstract class PuppyDetailsEvents {}

abstract class PuppyDetailsStates {
  Stream<String> get imagePath;

  Stream<String> get name;

  Stream<String?> get breed;

  Stream<String> get gender;

  Stream<String?> get characteristics;

  Stream<bool> get isFavourite;

  Stream<String> get genderAndBreed;

  Stream<Puppy> get puppy;
}

@RxBloc()
class PuppyDetailsBloc extends $PuppyDetailsBloc {
  PuppyDetailsBloc(
    CoordinatorBlocType coordinatorBloc, {
    required Puppy puppy,
  })  : _puppy = puppy,
        _coordinatorBlocType = coordinatorBloc;

  final Puppy _puppy;

  final CoordinatorBlocType _coordinatorBlocType;

  //get the latest updated version of the puppy
  @override
  Stream<Puppy> _mapToPuppyState() => _coordinatorBlocType
      .onPuppyUpdated(_puppy)
      .startWith(_puppy)
      .shareReplay(maxSize: 1);

  @override
  Stream<String?> _mapToBreedState() => puppy.mapToBreed();

  @override
  Stream<String?> _mapToCharacteristicsState() => puppy.mapToCharacteristics();

  @override
  Stream<String> _mapToGenderState() => puppy.mapToGender();

  @override
  Stream<String> _mapToImagePathState() => puppy.mapToImagePath();

  @override
  Stream<String> _mapToNameState() => puppy.name();

  @override
  Stream<bool> _mapToIsFavouriteState() => puppy.mapToIsFavourite();

  @override
  Stream<String> _mapToGenderAndBreedState() => puppy.mapToGenderAndBreed();
}

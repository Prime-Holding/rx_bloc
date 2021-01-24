import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'puppy_details_bloc.rxb.g.dart';

abstract class PuppyDetailsEvents {}

abstract class PuppyDetailsStates {
  Stream<String> get imagePath;

  Stream<String> get name;

  Stream<String> get breed;

  Stream<String> get gender;

  Stream<String> get characteristics;

  Stream<bool> get isFavourite;

  Stream<String> get genderAndCharacteristics;

  Stream<Puppy> get puppy;
}

@RxBloc()
class PuppyDetailsBloc extends $PuppyDetailsBloc {
  PuppyDetailsBloc(
    CoordinatorBlocType coordinatorBloc, {
    @required Puppy puppy,
  })  : _puppy = puppy,
        _coordinatorBlocType = coordinatorBloc;

  final Puppy _puppy;

  final CoordinatorBlocType _coordinatorBlocType;

  @override
  Stream<Puppy> _mapToPuppyState() =>
      _coordinatorBlocType.states.onPuppiesUpdated
          .map<Puppy>(
            (puppies) => puppies.firstWhere(
              (puppy) => puppy.id == _puppy.id,
              orElse: () => null,
            ),
          )
          .where((puppy) => puppy != null)
          .startWith(_puppy)
          .shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToBreedState() =>
      puppy.map((puppy) => puppy.breedTypeAsString);

  @override
  Stream<String> _mapToCharacteristicsState() =>
      puppy.map((puppy) => puppy.displayCharacteristics);

  @override
  Stream<String> _mapToGenderState() =>
      puppy.map((puppy) => puppy.genderAsString);

  @override
  Stream<String> _mapToImagePathState() => puppy.map((puppy) => puppy.asset);

  @override
  Stream<String> _mapToNameState() => puppy.map((puppy) => puppy.name);

  @override
  Stream<bool> _mapToIsFavouriteState() =>
      puppy.map((puppy) => puppy.isFavorite);

  @override
  Stream<String> _mapToGenderAndCharacteristicsState() => puppy
      .map((puppy) => '${puppy.genderAsString}, ${puppy.breedTypeAsString}');
}

part of 'puppy_manage_bloc.dart';

extension _PuppyUpdate on Stream<_MarkAsFavoriteEventArgs> {
  /// Mark the puppy as favorite as emitting an event with the updated puppy
  /// immediately, so that the listeners can update accordingly.
  ///
  /// Then send the request to the API and in case of success emits the updated
  /// puppy, otherwise emit an event with the origin puppy.
  ///
  /// `Side effect`: once the puppy gets updated emmit an event to
  /// [CoordinatorBloc]
  Stream<Puppy> markPuppyAsFavorite(
    PuppiesRepository puppiesRepository,
    PuppyManageBloc bloc,
  ) =>
      throttleTime(const Duration(milliseconds: 200))
          .switchMap<Result<Puppy>>((args) async* {
            yield Result.loading();
            // emit an event with the copied instance of the entity, so that UI
            // can update immediately
            yield Result.success(
              args.puppy.copyWith(isFavorite: args.isFavorite),
            );

            yield Result.loading();
            try {
              final updatedPuppy = await puppiesRepository
                  .favoritePuppy(args.puppy, isFavorite: args.isFavorite);

              yield Result.success(
                updatedPuppy.copyWith(
                  breedCharacteristics: args.puppy.breedCharacteristics,
                  displayCharacteristics: args.puppy.displayCharacteristics,
                  displayName: args.puppy.displayName,
                ),
              );
            } catch (e) {
              // In case of any error rollback the puppy to the previous state
              // and notify the UI layer for the error
              bloc._favoritePuppyError.sink.add(e);
              yield Result.success(args.puppy);
            }
          })
          .setResultStateHandler(bloc)
          .whereSuccess();
}

extension _PickImage on Stream<ImagePickerActions> {
  Stream<String> pickImagePath(PuppiesRepository repository) =>
      where((event) => event != null)
          .switchMap((source) => repository.pickPuppyImage(source).asStream())
          .where((event) => event != null)
          .map((event) => event.path);
}

extension _ValidateAllFields on PuppyManageBloc {
  Stream<bool> _validateAllFields() =>
      Rx.combineLatest4<String, String, Gender, BreedType, bool>(
        name,
        characteristics,
        gender,
        breed,
        (name, characteristics, gender, breed) => true,
      ).onErrorReturn(false);
}

extension _IsSavingAvailable on PuppyManageBloc {
  Stream<bool> _hasChanges() =>
      Rx.combineLatest5<String, String, String, Gender, BreedType, bool>(
        imagePath,
        name,
        characteristics,
        gender,
        breed,
        (imagePath, name, characteristics, gender, breed) =>
            imagePath != _puppy.asset ||
            name != _puppy.name ||
            characteristics != _puppy.displayCharacteristics ||
            gender != _puppy.gender ||
            breed != _puppy.breedType,
      );
}

extension _SavePuppy on PuppyManageBloc {
  Stream<Result<void>> _savePuppy() =>
      Rx.combineLatest5<String, String, String, Gender, BreedType, Puppy>(
        imagePath,
        name,
        characteristics,
        gender,
        breed,
        (imagePath, name, characteristics, gender, breed) => _puppy.copyWith(
          asset: imagePath,
          name: name,
          breedCharacteristics: characteristics,
          gender: gender,
          breedType: breed,
        ),
      ).switchMap<Result<Puppy>>((puppyWithChanges) async* {
        yield Result.loading();

        try {
          final updatedPuppy = await _puppiesRepository.updatePuppy(
            puppyWithChanges.id,
            puppyWithChanges,
          );

          _coordinatorBlocType.events.puppyUpdated(updatedPuppy);

          yield Result.success(updatedPuppy);
        } catch (e) {
          yield Result.error(e);
        }
      });
}

extension _ExceptionExtensions on Stream<Exception> {
  Stream<String> mapToString() =>
      map((e) => e.toString().replaceAll('Exception:', ''));
}

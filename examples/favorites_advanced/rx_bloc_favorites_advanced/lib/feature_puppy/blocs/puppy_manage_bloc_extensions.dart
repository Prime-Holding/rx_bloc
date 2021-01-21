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
          PuppiesRepository puppiesRepository, PuppyManageBloc bloc) =>
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
          .map((event) => event?.path);
}

// extension _IsSavingAvailable on PuppyManageBloc {
//   Stream<bool> _isSavingAvailable() => Rx.combineLatest6(
//         puppy.startWith(null),
//         _updateName.whereSuccess().startWith(null),
//         selectedGender.startWith(null),
//         selectedBreed.startWith(null),
//         _updateCharacteristics.whereSuccess().startWith(null),
//         pickedImagePath.startWith(null),
//         (puppy, name, gender, breed, characteristics, imagePath) =>
//             (puppy.name != name && name != null) ||
//             (puppy.breedType != breed && breed != null) ||
//             (puppy.gender != gender && gender != null) ||
//             (puppy.breedCharacteristics != characteristics &&
//                 characteristics != null) ||
//             imagePath != null,
//       );
// }
//
// extension _EditPuppy on Stream<void> {
//   Stream<Puppy> editPuppy() => withLatestFrom6(
//           _nameSubject,
//           _characteristicsSubject,
//           _genderSubject,
//           _breedSubject,
//           _imagePath,
//           _puppySubject,
//           (_, name, characteristics, gender, breed, imagePath, puppy) =>
//               _UpdatePuppyData(
//                 name: name,
//                 characteristics: characteristics,
//                 imagePath: imagePath,
//                 gender: gender,
//                 breed: breed,
//                 puppy: puppy,
//               ))
//       .switchMap((args) => _verifyAndUpdatePuppy(args).asResultStream())
//       .setResultStateHandler(this)
//       .whereSuccess();
// }
//
// extension _UpdatePuppyExtension on PuppyManageBloc {
//   Stream<Puppy> editPuppy() => _$updatePuppyEvent
//       .withLatestFrom6(
//           _nameSubject,
//           _characteristicsSubject,
//           _genderSubject,
//           _breedSubject,
//           _imagePath,
//           _puppySubject,
//           (_, name, characteristics, gender, breed, imagePath, puppy) =>
//               _UpdatePuppyData(
//                 name: name,
//                 characteristics: characteristics,
//                 imagePath: imagePath,
//                 gender: gender,
//                 breed: breed,
//                 puppy: puppy,
//               ))
//       .switchMap((args) => _verifyAndUpdatePuppy(args).asResultStream())
//       .setResultStateHandler(this)
//       .whereSuccess();
//
//   void _resetErrorStreams() {
//     _nameErrorSubject.add(null);
//     _characteristicsErrorSubject.add(null);
//   }
//
//   Future<Puppy> _verifyAndUpdatePuppy(_UpdatePuppyData data) async {
//     _resetErrorStreams();
//
//     // Verify if the entered data is valid
//     if (!_dataIsValid(data)) return Future.value(null);
//
//     // Now update the puppy
//     final pup = data.puppy;
//     final puppyToUpdate = pup.copyWith(
//       name: data.name?.trim() ?? pup.name,
//       breedCharacteristics:
//           data.characteristics?.trim() ?? pup.breedCharacteristics,
//       gender: data.gender ?? pup.gender,
//       breedType: data.breed ?? pup.breedType,
//       asset: data.imagePath ?? pup.asset,
//     );
//
//     return _puppiesRepository.updatePuppy(pup.id, puppyToUpdate);
//   }
//
//   bool _dataIsValid(_UpdatePuppyData data) {
//     var isValid = true;
//     final pup = data.puppy;
//     // Verify name length
//     final editedName = (data.name ?? pup.name).trim();
//     if (editedName.isEmpty || editedName.length > _maxNameLength) {
//       if (editedName.isEmpty) _nameErrorSubject.add('Name cannot be empty.');
//       if (editedName.length > _maxNameLength) {
//         _nameErrorSubject.add('Name too long.');
//       }
//       isValid = false;
//     }
//
//     // Verify characteristics length
//     final editedDetails =
//         (data.characteristics ?? pup.breedCharacteristics).trim();
//     if (editedDetails.isEmpty ||
//         editedDetails.length > _maxCharacteristicsLength) {
//       if (editedDetails.isEmpty) {
//         _characteristicsErrorSubject.add('Characteristics cannot be empty.');
//       }
//       if (editedDetails.length > _maxNameLength) {
//         _characteristicsErrorSubject.add(
//             // ignore: lines_longer_than_80_chars
//             'Characteristics exceed max length of $_maxCharacteristicsLength characters.');
//       }
//       isValid = false;
//     }
//
//     return isValid;
//   }
//
//   Stream<bool> _isSavingAvailable() => Rx.combineLatest6(
//         _puppySubject,
//         _nameSubject,
//         _genderSubject,
//         _breedSubject,
//         _characteristicsSubject,
//         _imagePath,
//         (puppy, name, gender, breed, characteristics, imagePath) =>
//             (puppy.name != name && name != null) ||
//             (puppy.breedType != breed && breed != null) ||
//             (puppy.gender != gender && gender != null) ||
//             (puppy.breedCharacteristics != characteristics &&
//                 characteristics != null) ||
//             imagePath != null,
//       );
// }
//
// extension _ExceptionExtensions on Stream<Exception> {
//   Stream<String> mapToString() =>
//       map((e) => e.toString().replaceAll('Exception:', ''));
// }

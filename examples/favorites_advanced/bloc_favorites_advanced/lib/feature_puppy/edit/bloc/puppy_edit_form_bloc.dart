import 'dart:async';
import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:bloc_sample/feature_puppy/validators/puppy_form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:rxdart/rxdart.dart';

part 'puppy_edit_form_event.dart';

part 'puppy_edit_form_state.dart';

class PuppyEditFormBloc extends FormBloc<String, String> {
  PuppyEditFormBloc({
    required this.coordinatorBloc,
    required this.repository,
    required Puppy puppy,
  })   : _puppy = puppy,
        _editedPuppy = puppy,
        super(autoValidate: false, isLoading: true) {
    addFieldBlocs(
      fieldBlocs: [
        image,
        name,
        breed,
        gender,
        characteristics,
      ],
    );

    image.onValueChanges(onData: (previous, current) async* {
      // print('onValueChanges ImagePickerAction: ${current.value}');
      final pickedImage = await repository.pickPuppyImage(current.value!);
      // print('pickedImage.path: ${pickedImage?.path}');
      if (pickedImage != null) {
        final newPath = pickedImage.path;
        // print('NEW pickedImage.path: $newPath');
        _asset.sink.add(newPath);
        setImagePath(newPath);

        // print('_editedPuppy.asset: ${_editedPuppy.asset}' );
        emitUpdatingFields();
        emitLoaded();
        // print(current.value);
        // print('_asset.sink.add(pickedImage.path): ${pickedImage.path}');
      }
    });

    name.onValueChanges(
      onData: (previous, current) async* {
        if (previous != current) {
          _name.sink.add(current.value.toString());
          final newName = current.value.toString();
          if (_puppy.name != newName) {
            final nameValidated = PuppyFormValidator.nameValidation(newName);
            if (nameValidated == null) {
              setName(newName);
              emitUpdatingFields();
            }
            emitLoaded();
          }
        }
      },
    );

    breed.onValueChanges(
      onData: (previous, current) async* {
        if (previous != current) {
          _breed.sink.add(current.value ?? BreedType.None);
          if (_puppy.breedType != current.value) {
            final newBreed = current.value;
            final breedValidated = PuppyFormValidator.breedValidation(newBreed);
            if (breedValidated == null) {
              setBreed(newBreed!);
            }
            emitUpdatingFields();
          }
          emitLoaded();
        }
      },
    );

    gender.onValueChanges(
      onData: (previous, current) async* {
        if (previous != current) {
          _gender.sink.add(current.value ?? Gender.None);
          if (_puppy.gender.toString().substring(7) !=
              current.value.toString()) {
            final newGender = current.value;
            final genderValidated =
                PuppyFormValidator.genderValidation(newGender);
            if (genderValidated == null) {
              setGender(newGender ?? _editedPuppy.gender);
            }
            emitUpdatingFields();
          }
          emitLoaded();
        }
      },
    );

    characteristics.onValueChanges(
      onData: (previous, current) async* {
        if (previous != current) {
          _characteristics.sink.add(current.value.toString());
          if (_puppy.displayCharacteristics != current.value) {
            final newCharacteristics = current.value.toString();
            final characteristicsValidated =
                PuppyFormValidator.characteristicsValidation(
                    newCharacteristics);
            if (characteristicsValidated == null) {
              setCharacteristics(newCharacteristics);
            }
            emitUpdatingFields();
          }
          emitLoaded();
        }
      },
    );
  }

  final Puppy _puppy;
  late Puppy _editedPuppy;
  final PuppiesRepository repository;
  final CoordinatorBloc coordinatorBloc;

  static const _submitSuccessResponse = 'The puppy was saved successfully.';
  static const _submissionFailureResponse =
      'No Internet Connection. Please check your settings.';

  final _asset = BehaviorSubject<String>();
  final _name = BehaviorSubject<String>();
  final _gender = BehaviorSubject<Gender>();
  final _characteristics = BehaviorSubject<String>();
  final _breed = BehaviorSubject<BreedType>();

  Stream<String> get asset$ => _asset.stream.startWith(_puppy.asset);

  Stream<String> get name$ => _name.stream.startWith(_puppy.name);

  Stream<Gender> get gender$ => _gender.stream.startWith(_puppy.gender);

  Stream<String> get characteristics$ =>
      _characteristics.stream.startWith(_puppy.displayCharacteristics ?? '');

  Stream<BreedType> get breed$ => _breed.stream.startWith(_puppy.breedType);

  Stream<bool> get isFormValid$ => Rx.combineLatest5(
        asset$,
        name$,
        gender$,
        breed$,
        characteristics$,
        (asset, name, gender, breed, characteristics) =>
            asset != _puppy.asset ||
            name != _puppy.name ||
            gender != _puppy.gender ||
            breed != _puppy.breedType ||
            characteristics != _puppy.displayCharacteristics,
      ).startWith(false);

  void dispose() {
    _asset.close();
    _name.close();
    _gender.close();
    _breed.close();
    _characteristics.close();
  }

  void setImagePath(String value) =>
      _editedPuppy = _editedPuppy.copyWith(asset: value);

  void setName(String value) =>
      _editedPuppy = _editedPuppy.copyWith(name: value);

  void setBreed(BreedType value) =>
      _editedPuppy = _editedPuppy.copyWith(breedType: value);

  void setGender(Gender value) =>
      _editedPuppy = _editedPuppy.copyWith(gender: value);

  void setCharacteristics(String value) => _editedPuppy = _editedPuppy.copyWith(
      displayCharacteristics: value, breedCharacteristics: value);

  final InputFieldBloc<ImagePickerAction, Object> image = InputFieldBloc();

  final name = TextFieldBloc(
    validators: [
      PuppyFormValidator.nameValidation,
    ],
  );

  final breed = SelectFieldBloc(
    items: BreedType.values,
    validators: [
      PuppyFormValidator.breedValidation,
    ],
  );

  final gender = SelectFieldBloc(
    items: [Gender.Male, Gender.Female],
    validators: [PuppyFormValidator.genderValidation],
  );

  final characteristics = TextFieldBloc(
    validators: [PuppyFormValidator.characteristicsValidation],
  );

  @override
  void onLoading() {
    try {
      name.updateInitialValue(_puppy.name);
      breed.updateInitialValue(_puppy.breedType);
      gender.updateInitialValue(_puppy.gender);
      characteristics.updateInitialValue(_puppy.displayCharacteristics);
      emitLoaded();
    } catch (e) {
      emitLoadFailed();
    }
  }

  @override
  // ignore: avoid_void_async
  void onSubmitting() async {
    try {
      emitSubmitting();
      final updatedPuppy =
          await repository.updatePuppy(_editedPuppy.id, _editedPuppy);
      // print('updatedPuppy: $updatedPuppy');
      coordinatorBloc
        ..add(CoordinatorPuppyUpdatedEvent(updatedPuppy))
        ..add(CoordinatorFavoritePuppyUpdatedEvent(
          favoritePuppy: updatedPuppy,
          updateException: '',
        ));

      emitSuccess(successResponse: _submitSuccessResponse);
    } catch (e) {
      emitFailure(failureResponse: _submissionFailureResponse);
    }
  }
}

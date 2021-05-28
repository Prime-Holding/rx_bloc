import 'dart:async';
import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:rxdart/rxdart.dart';

part 'puppy_edit_form_event.dart';

part 'puppy_edit_form_state.dart';

class PuppyEditFormBloc extends FormBloc<String, String> {
  PuppyEditFormBloc(
      {required this.coordinatorBloc,
      required this.repository,
      required Puppy puppy})
      : _puppy = puppy,
        _editedPuppy = puppy,
        super(autoValidate: false, isLoading: true) {
    addFieldBlocs(
      fieldBlocs: [
        image,
        // isSaveEnabled,
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

    name.onValueChanges(onData: (previous, current) async* {
      if (previous != current) {
        // print('name current value: ${current.value}');
        _name.sink.add(current.value.toString());
        final newName = current.value.toString();
        if (_puppy.name != newName) {
          // print('NEW Name $newName');
          if (newName.trim().length < 30) {
            setName(newName);
          }
          // print('_editedPuppy.name: ${_editedPuppy.name}');
          emitUpdatingFields();
          emitLoaded();
        } else {
          emitLoaded();
        }
      }
    });

    gender.onValueChanges(
      onData: (previous, current) async* {
        if (previous != current) {
          // print('gender current value: ${current.value}');
          _gender.sink.add(current.value ?? Gender.None);
          if (_puppy.gender.toString().substring(7) !=
              current.value.toString()) {
            final newGender = current.value;
            // print('NEW Gender:$newGender');
            setGender(newGender ?? _editedPuppy.gender);
            // print('_editedPuppy.gender: ${_editedPuppy.gender}');
            emitUpdatingFields();
            emitLoaded();
          } else {
            emitLoaded();
          }
        }
      },
    );

    breed.onValueChanges(
      onData: (previous, current) async* {
        if (previous != current) {
          // print('breed current value: ${current.value}');
          _breed.sink.add(current.value ?? BreedType.None);
          if (_puppy.breedType != current.value) {
            final newBreed = current.value;
            // print('New Breed: $newBreed');
            if (newBreed != null && newBreed != BreedType.None) {
              setBreed(newBreed);
            }
            // print('_editedPuppy.breedType ${_editedPuppy.breedType}');

            emitUpdatingFields();
            emitLoaded();
          } else {
            emitLoaded();
          }
        }
      },
    );

    characteristics.onValueChanges(
      onData: (previous, current) async* {
        if (previous != current) {
          // print('displayCharacteristics current value: ${current.value}');
          _characteristics.sink.add(current.value.toString());
          if (_puppy.displayCharacteristics != current.value) {
            final newCharacteristics = current.value;
            // print('New Characteristics: $newCharacteristics');
            if (newCharacteristics != null &&
                newCharacteristics.trim().length < 250 &&
                newCharacteristics.trim().isNotEmpty) {
              setCharacteristics(newCharacteristics);
            }
            // print(
            //     '_editedPuppy.displayCharacteristics:
            //     ${_editedPuppy.displayCharacteristics}');

            emitUpdatingFields();
            emitLoaded();
          } else {
            emitLoaded();
          }
        }
      },
    );
  }

  // CoordinatorBloc _coordinatorBloc;
  final Puppy _puppy;
  late Puppy _editedPuppy;
  final PuppiesRepository repository;
  final CoordinatorBloc coordinatorBloc;
  static const int _maxCharacteristicsLength = 250;
  static const int _maxNameLength = 30;
  static const _nameMustNotBeEmpty = 'Name must not be empty.';
  static const _nameTooLong = 'Name too long.';
  static const _selectABreed = 'You have to select a breed.';
  static const _selectAGender = 'You have to select a gender.';
  static const _charMustNotBeEmpty = 'Characteristics must not be empty';
  static const _charLengthLimitation = 'Characteristics must not exceed '
      '$_maxCharacteristicsLength characters.';

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

  // final isSaveEnabled = BooleanFieldBloc();

  final InputFieldBloc<ImagePickerAction, Object> image = InputFieldBloc();

  final name = TextFieldBloc(
    validators: [
      _nameValidation,
    ],
  );

  // Test string
  //0123456789012345678901234567891
  static String? _nameValidation(String? username) {
    if (username != null && username.isEmpty) {
      return _nameMustNotBeEmpty;
    }

    if (username != null && username.length > _maxNameLength) {
      return _nameTooLong;
    }
    return null;
  }

  final breed = SelectFieldBloc(
    items: BreedType.values,
    validators: [
      _breedValidation,
    ],
  );

  final gender = SelectFieldBloc(
    // items: ['Male', 'Female'],
    items: [Gender.Male, Gender.Female],
    validators: [_genderValidation],
  );

  final characteristics = TextFieldBloc(
    validators: [_characteristicsValidation],
  );

  static String? _breedValidation(BreedType? breedType) {
    if (breedType == BreedType.None || breedType == null) {
      return _selectABreed;
    }
    return null;
  }

  static String? _genderValidation(Gender? gender) {
    if (gender == Gender.None || gender == null) {
      return _selectAGender;
    }
    return null;
  }

  static String? _characteristicsValidation(String? characteristics) {
    if (characteristics!.isEmpty) {
      return _charMustNotBeEmpty;
    }

    final trimmedChars = characteristics.trim();

    if (trimmedChars.length > _maxCharacteristicsLength) {
      return _charLengthLimitation;
    }
    return null;
  }

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
    // print('onSubmitting ${name.value}');
    // print('onSubmitting ${breed.value}');
    // print(gender.value);
    // print(characteristics.value);

    try {
      // print('onSubmitting name.value: ${name.value}');

      emitSubmitting();
      await Future.delayed(const Duration(milliseconds: 200));
      final updatedPuppy =
          await repository.updatePuppy(_editedPuppy.id, _editedPuppy);
      // print('updatedPuppy: $updatedPuppy');
      coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(updatedPuppy));
      await Future.delayed(const Duration(milliseconds: 100));

      coordinatorBloc.add(CoordinatorFavoritePuppyUpdatedEvent(
        favoritePuppy: updatedPuppy,
        updateException: '',
      ));

      emitSuccess();
    } catch (e) {
      emitFailure();
    }
  }
}

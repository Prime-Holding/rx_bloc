import 'dart:async';

import 'package:bloc_sample/feature_puppy/edit/ui_components/puppy_edit_form.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:rxdart/rxdart.dart';

class PuppyEditFormBloc extends FormBloc<String, String> {
  PuppyEditFormBloc({required Puppy puppy})
      : _puppy = puppy,
        // puppy1 = puppy,
        super(autoValidate: false, isLoading: true) {
    addFieldBlocs(
      fieldBlocs: [
        name,
        breed,
        gender,
        characteristics,
      ],
    );

    name.onValueChanges(onData: (previous, current) async* {
      if (previous != current) {
        // print('name current value: ${current.value}');
        _name.sink.add(current.value.toString());

        if (_puppy.name != current.value.toString()) {
          emitUpdatingFields();
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
            // _gender.sink.add(current.value.toString());

            emitUpdatingFields();
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
            emitUpdatingFields();
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
            emitUpdatingFields();
          } else {
            emitLoaded();
          }
        }
      },
    );

    // _coordinatorBloc.stream.listen((event) {
    //   if(event is CoordinatorPuppiesUpdatedState){
    //     add(event.puppies)
    //   }
    // })
    // print('Constructor $_puppy');
  }

  // CoordinatorBloc _coordinatorBloc;
  final Puppy _puppy;

  // static  Puppy? puppy1;
  static const int _maxCharacteristicsLength = 250;
  static const int _maxNameLength = 30;

  final _name = BehaviorSubject<String>();
  final _gender = BehaviorSubject<Gender>();
  final _characteristics = BehaviorSubject<String>();
  final _breed = BehaviorSubject<BreedType>();

  Stream<String> get name$ => _name.stream.startWith(_puppy.name);

  Stream<Gender> get gender$ => _gender.stream.startWith(_puppy.gender);

  Stream<String> get characteristics$ =>
      _characteristics.stream.startWith(_puppy.displayCharacteristics ?? '');

  Stream<BreedType> get breed$ => _breed.stream.startWith(_puppy.breedType);

  Stream<bool> get isFormValid$ => Rx.combineLatest4(
        name$,
        gender$,
        breed$,
        characteristics$,
        (name, gender, breed, characteristics) =>
            name != _puppy.name ||
            gender != _puppy.gender ||
            breed != _puppy.breedType ||
            characteristics != _puppy.displayCharacteristics,
      ).startWith(false);

  // bool isSaveEnabled() {
  //   final String name = _name.value!;
  //   print('');
  //   return false;
  // return _name != _puppy.name ||
  //     _gender != _puppy.gender;
  // }

  // late Gender _gender = Gender.None;

  final name = TextFieldBloc(
    // initialValue: PuppyEditForm.puppyPublic?.name,
    // initialValue: puppy1!.name,
    validators: [
      // FieldBlocValidators.required,
      _nameValidation,
    ],
  );

  // Stream<bool> test;
  // test.listen((event) {})
  // Stream<FormBlocState> _hasChanges() {
  //   return Rx.combineLatest4(
  //       Stream.value(onValueChanges), streamB, streamC, streamD,
  //           (a, b, c, d) => null)
  // }

  // Test string
  //0123456789012345678901234567891
  static String? _nameValidation(String? username) {
    if (username != null && username.isEmpty) {
      return 'Name must not be empty.';
    }

    if (username != null && username.length > _maxNameLength) {
      return 'Name too long.';
    }
    return '';
  }

  final breed = SelectFieldBloc(
    items: BreedType.values,
    // initialValue: PuppyEditForm.puppyPublic?.breedType,
    validators: [
      _breedValidation,
    ],
  );

  final gender = SelectFieldBloc(
    // items: ['Male', 'Female'],
    items: [Gender.Male, Gender.Female],
    // initialValue: PuppyEditForm.puppyPublic?.gender.toString().substring(7),
    validators: [_genderValidation],
  );

  final characteristics = TextFieldBloc(
    // initialValue: 'initial characteristics',
    // initialValue: PuppyEditForm.puppyPublic?.displayCharacteristics,
    validators: [_characteristicsValidation],
  );

  static String? _breedValidation(BreedType? breedType) {
    if (breedType == BreedType.None) {
      return 'You have to select a breed.';
    }

    return null;
  }

  static String? _genderValidation(Gender? gender) {
    if (gender == Gender.None) {
      return 'You have to select a gender.';
    }
    return null;
  }

  static String? _characteristicsValidation(String? characteristics) {
    if (characteristics!.isEmpty) {
      return 'Characteristics must not be empty';
    }

    final trimmedChars = characteristics.trim();

    if (trimmedChars.length > _maxCharacteristicsLength) {
      return 'Characteristics must not exceed '
          '$_maxCharacteristicsLength characters.';
    }
    return null;
  }

  @override
  // ignore: avoid_void_async
  void onLoading() async {
    try {
      // await Future<void>.delayed(const Duration(milliseconds: 1500));

      // name.updateInitialValue('TEST');
      // name.updateInitialValue(PuppyEditForm.puppyPublic?.name);
      name.updateInitialValue(_puppy.name);
      breed.updateInitialValue(_puppy.breedType);
      gender.updateInitialValue(_puppy.gender);
      characteristics.updateInitialValue(_puppy.displayCharacteristics);
      // print('onLoading ${name.value}');
      emitLoaded();
    } catch (e) {
      emitLoadFailed();
    }
  }

  @override
  // ignore: avoid_void_async
  void onSubmitting() async {
    ///Send event to coordinator
    try {
      // print('onSubmitting name.value: ${name.value}');
      await Future<void>.delayed(const Duration(milliseconds: 500));

      emitSubmitting();
    } catch (e) {
      // print('onSubmitting error: ${e.toString()}');

      emitFailure();
    }

    // print(name.value);
    // print(breed.value);
    // print(gender.value);
    // print(characteristics.value);
  }
}

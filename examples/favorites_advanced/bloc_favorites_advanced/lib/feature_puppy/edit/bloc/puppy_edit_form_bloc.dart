import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:rxdart/rxdart.dart';

part 'puppy_edit_form_event.dart';
part 'puppy_edit_form_state.dart';

class PuppyEditFormBloc extends FormBloc<String, String> {
  PuppyEditFormBloc({required this.repository,required Puppy puppy})
      : _puppy = puppy,
        // puppy1 = puppy,
        super(autoValidate: false, isLoading: true) {
    addFieldBlocs(
      fieldBlocs: [
        // isSaveEnabled,
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

  }

  // CoordinatorBloc _coordinatorBloc;
  final Puppy _puppy;
  final PuppiesRepository repository;
  static const int _maxCharacteristicsLength = 250;
  static const int _maxNameLength = 30;

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
  // final isSaveEnabled = BooleanFieldBloc();

  final name = TextFieldBloc(
    validators: [
      _nameValidation,
    ],
  );

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

  // @override
  // Stream<FormBlocState<String, String>> mapEventToState(
  //     FormBlocEvent event) async* {
  //   if(event is PuppyEditFormSetImageEvent){
  //   //   var source = event.source;
  //   //   print('mapEventToState event.source: ${event.source}');
  //   //   emitLoaded();
  //   //   // yield FormBlocLoaded();
  //     yield  PuppyEditFormState(path: '');
  //   }else if(event is LoadFormBloc){
  //     emitLoading(progress: 1);
  //   }
  //   // yield FormBlocLoading(progress: 1);
  //   // emitSuccess();
  //
  //   yield FormBlocLoading(progress: 1);
  //   // yield state.toLoaded();
  // }

  @override
  // ignore: avoid_void_async
  void onLoading() async {
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

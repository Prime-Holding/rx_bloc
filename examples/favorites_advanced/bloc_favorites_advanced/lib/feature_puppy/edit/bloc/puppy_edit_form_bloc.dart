import 'package:bloc_sample/feature_puppy/edit/ui_components/puppy_edit_form.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';

class PuppyEditFormBloc extends FormBloc<String, String> {
  PuppyEditFormBloc() {
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
        // print('emitUpdatingFields current value: ${current.value}');
        await Future.delayed(const Duration(seconds: 1));
        emitUpdatingFields();
      } else {
        // print('emitFailure current value: ${current.value}');
        emitFailure();
      }
    });

    breed.onValueChanges(
      onData: (previous, current) async* {
        if (previous != current) {
          try {
            // print('emitUpdatingFields current value: ${current.value}');
            await Future.delayed(const Duration(seconds: 1));
            emitUpdatingFields();
          } catch (e) {
            // print('emitFailure current value: ${current.value}');
            emitFailure();
          }
        }
      },
    );
    gender.onValueChanges(
      onData: (previous, current) async* {
        if (previous != current) {
          try {
            // print('emitUpdatingFields current value: ${current.value}');
            await Future.delayed(const Duration(seconds: 1));
            emitUpdatingFields();
          } catch (e) {
            // print('emitFailure current value: ${current.value}');
            emitFailure();
          }
        }
      },
    );

    characteristics.onValueChanges(
      onData: (previous, current) async* {
        if (previous != current) {
          try {
            // print('emitUpdatingFields current value: ${current.value}');
            await Future.delayed(const Duration(seconds: 1));
            emitUpdatingFields();
          } catch (e) {
            // print('emitFailure current value: ${current.value}');
            emitFailure();
          }
        }
      },
    );

    // _coordinatorBloc.stream.listen((event) {
    //   if(event is CoordinatorPuppiesUpdatedState){
    //     add(event.puppies)
    //   }
    // })
  }

  // CoordinatorBloc _coordinatorBloc;

  static const int _maxCharacteristicsLength = 250;
  static const int _maxNameLength = 30;

  final name = TextFieldBloc(
    initialValue: PuppyEditForm.puppyPublic?.name,
    validators: [
      // FieldBlocValidators.required,
      _nameValidation,
    ],
  );

  final breed = SelectFieldBloc(
    items: BreedType.values,
    initialValue: PuppyEditForm.puppyPublic?.breedType,
    validators: [
      _breedValidation,
    ],
  );

  final gender = SelectFieldBloc(
    items: ['Male', 'Female'],
    initialValue: PuppyEditForm.puppyPublic?.gender.toString().substring(7),
    validators: [_genderValidation],
  );

  final characteristics = TextFieldBloc(
    // initialValue: 'initial characteristics',
    initialValue: PuppyEditForm.puppyPublic?.displayCharacteristics,
    validators: [_characteristicsValidation],
  );

  // Test string
  //0123456789012345678901234567891
  static String? _nameValidation(String? username) {
    if (username!.isEmpty) {
      return 'Name must not be empty.';
    }

    if (username.length > _maxNameLength) {
      return 'Name too long.';
    }
    return null;
  }

  static String? _breedValidation(BreedType? breedType) {
    if (breedType == BreedType.None) {
      return 'You have to select a breed.';
    }

    return null;
  }

  static String? _genderValidation(String? gender) {
    if (gender == null) {
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
  void onSubmitting() async {
    ///Send event to coordinator
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      emitSubmitting();
    } catch (e) {
      emitFailure();
    }

    // print(name.value);
    // print(breed.value);
    // print(gender.value);
    // print(characteristics.value);
  }
}

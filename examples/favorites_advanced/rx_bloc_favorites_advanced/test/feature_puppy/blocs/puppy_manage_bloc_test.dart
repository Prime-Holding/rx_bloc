import 'package:favorites_advanced_base/core.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/blocs/puppy_manage_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/validators/puppy_validator.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import '../../mocks.dart';
import '../../stubs.dart';

void main() {
  late CoordinatorBlocType coordinatorMock;
  late PuppiesRepositoryMock repositoryMock;

  setUp(() {
    coordinatorMock = CoordinatorBlocMock();
    repositoryMock = PuppiesRepositoryMock();
  });

  group('PuppyManageBloc edit puppy', () {
    rxBlocTest<PuppyManageBloc, String>(
      'PuppyManageBloc.imagePath set puppy asset: '
      'success triggered by setImage',
      build: () async => PuppyManageBloc(
        repositoryMock,
        coordinatorMock,
        puppy: Stub.puppy1,
        validator: const PuppyValidator(),
      ),
      state: (bloc) => bloc.states.imagePath,
      act: (bloc) async {
        //  Nothing should be emitted when you pick null
        //as the source for the image.
        // bloc.events.setImage(null);

        //when you pick the camera as image source
        await Future.delayed(Stub.pickImageDelay);
        when(repositoryMock.pickPuppyImage(ImagePickerAction.camera))
            .thenAnswer((_) async => PickedFile('camera image'));
        bloc.events.setImage(ImagePickerAction.camera);

        //  Nothing should be emitted when the gallery returns null
        //as the picked image, which could happen if the user cancels
        //picking the image.
        await Future.delayed(Stub.pickImageDelay);
        when(repositoryMock.pickPuppyImage(any!)).thenAnswer((_) async => null);
        bloc.events.setImage(ImagePickerAction.gallery);

        //when you pick the gallery as image source
        await Future.delayed(Stub.pickImageDelay);
        when(repositoryMock.pickPuppyImage(ImagePickerAction.gallery))
            .thenAnswer((_) async => PickedFile('gallery image'));
        bloc.events.setImage(ImagePickerAction.gallery);
      },
      expect: [
        //the bloc starts with the image from the puppy passed to it.
        Stub.puppy1.asset,
        //when a camera is picked as the source for the image.
        'camera image',
        //when the gallery is picked as the source for the image.
        'gallery image',
      ],
    );

    rxBlocTest<PuppyManageBloc, String>(
      'PuppyManageBloc.name set puppy name: '
      'success triggered by setName',
      build: () async => PuppyManageBloc(
        repositoryMock,
        coordinatorMock,
        puppy: Stub.puppy1,
      ),
      state: (bloc) => bloc.states.name,
      act: (bloc) async {
        bloc.events.setName('');
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setName(Stub.string31);
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setName('test');
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setName('');
      },
      expect: [
        //starts with the name of the puppy passed to the bloc
        Stub.puppy1.name,
        //throws name empty error when name is set to empty string
        Stub.nameEmptyErr,
        //throws name too long error when name is set
        //to a string longer than 30 chars
        Stub.nameTooLongErr,
        //when name is set to a valid string, it immediately returns said string
        'test',
        //when name is set to null, returns same error as 'name empty error'
        //but with a value of null
        Stub.nameNullErr,
      ],
    );

    rxBlocTest<PuppyManageBloc, BreedType>(
      'PuppyManageBloc.breed set puppy breed: '
      'success triggered by setBreed',
      build: () async => PuppyManageBloc(
        repositoryMock,
        coordinatorMock,
        puppy: Stub.puppy1,
      ),
      state: (bloc) => bloc.states.breed,
      act: (bloc) async {
        bloc.events.setBreed(BreedType.None);
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setBreed(BreedType.Akita);
      },
      expect: [
        //starts with the breed of the puppy passed to the bloc
        Stub.puppy1.breedType,
        //throws exception if breed is set to none
        isA<RxFieldException<BreedType>>(),
        //if breed is valid, return it
        BreedType.Akita,
      ],
    );

    rxBlocTest<PuppyManageBloc, Gender>(
      'PuppyManageBloc.gender set puppy gender: '
      'success triggered by setGender',
      build: () async => PuppyManageBloc(
        repositoryMock,
        coordinatorMock,
        puppy: Stub.puppy1,
      ),
      state: (bloc) => bloc.states.gender,
      act: (bloc) async {
        bloc.events.setGender(Gender.None);
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setGender(Gender.Female);
      },
      expect: [
        //starts with the gender of the puppy passed to the bloc
        Stub.puppy1.gender,
        //throws exception if gender is set to none
        isA<RxFieldException<Gender>>(),
        Gender.Female,
      ],
    );

    rxBlocTest<PuppyManageBloc, String>(
      'PuppyManageBloc.characteristics set puppy characteristics: '
      'success triggered by setCharacteristics',
      build: () async => PuppyManageBloc(
        repositoryMock,
        coordinatorMock,
        puppy: Stub.puppiesWithDetails[0],
        validator: PuppyValidator(),
      ),
      state: (bloc) => bloc.states.characteristics,
      act: (bloc) async {
        bloc.events.setCharacteristics('');
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setCharacteristics(Stub.string251);
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setCharacteristics('test');
      },
      expect: [
        //starts with the gender of the puppy passed to the bloc
        Stub.puppiesWithDetails[0].displayCharacteristics,
        Stub.characteristicsEmptyErr,
        Stub.characteristicsTooLongErr,
        'test',
      ],
    );

    rxBlocTest<PuppyManageBloc, bool>(
      'PuppyManageBloc.showErrors set showErrors: '
      'success triggered by savePuppy',
      build: () async => PuppyManageBloc(
        repositoryMock,
        coordinatorMock,
        puppy: Stub.puppiesWithDetails[0],
      ),
      state: (bloc) => bloc.states.showErrors,
      act: (bloc) async {
        //subscribe to all fields that are validated,
        //because of lazy evaluation in RxBloc
        bloc.states.name.listen((event) {}, onError: (error) {});
        bloc.states.breed.listen((event) {}, onError: (error) {});
        bloc.states.gender.listen((event) {}, onError: (error) {});
        bloc.states.characteristics.listen((event) {}, onError: (error) {});

        //starts with false, so set name to invalid value so that it would
        //be triggered and set to true
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setName('');
        bloc.events.savePuppy();

        //set name to valid value and save,
        //so that it would be set to false again
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setName('aaa');
        bloc.events.savePuppy();
      },
      expect: [
        false,
        true,
        false,
      ],
    );

    rxBlocTest<PuppyManageBloc, bool>(
      'PuppyManageBloc.isSaveEnabled set isSaveEnabled',
      build: () async => PuppyManageBloc(
        repositoryMock,
        coordinatorMock,
        puppy: Stub.puppiesWithDetails[0],
      ),
      state: (bloc) => bloc.states.isSaveEnabled,
      act: (bloc) async {
        bloc.states.imagePath.listen((event) {}, onError: (error) {});
        bloc.states.name.listen((event) {}, onError: (error) {});
        bloc.states.breed.listen((event) {}, onError: (error) {});
        bloc.states.gender.listen((event) {}, onError: (error) {});
        bloc.states.characteristics.listen((event) {}, onError: (error) {});

        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setName('aaa');
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setName(Stub.puppiesWithDetails[0].name);

        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setBreed(BreedType.Akita);
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setBreed(Stub.puppiesWithDetails[0].breedType);

        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setGender(Gender.Female);
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setGender(Stub.puppiesWithDetails[0].gender);

        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setCharacteristics('aaa');
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.events.setCharacteristics(
            Stub.puppiesWithDetails[0].displayCharacteristics!);
      },
      expect: [
        false,
        false,
        true,
        false,
        true,
        false,
        true,
        false,
        true,
        false,
      ],
    );

    rxBlocTest<PuppyManageBloc, dynamic>(
      'PuppyManageBloc.updateComplete and  PuppyManageBloc.error, '
      'save puppy: success triggered by savePuppy',
      build: () async => PuppyManageBloc(
        repositoryMock,
        coordinatorMock,
        puppy: Stub.puppiesWithDetails[0],
        validator: PuppyValidator(),
      ),
      state: (bloc) => MergeStream([
        bloc.states.error,
        bloc.states.updateComplete,
      ]),
      act: (bloc) async {
        bloc.states.imagePath.listen((event) {}, onError: (error) {});
        bloc.states.name.listen((event) {}, onError: (error) {});
        bloc.states.breed.listen((event) {}, onError: (error) {});
        bloc.states.gender.listen((event) {}, onError: (error) {});
        bloc.states.characteristics.listen((event) {}, onError: (error) {});

        await Future.delayed(const Duration(milliseconds: 10));
        when(repositoryMock.updatePuppy(any!, any!))
            .thenAnswer((_) async => throw Stub.testErr);
        bloc.events.savePuppy();

        await Future.delayed(const Duration(milliseconds: 10));
        when(repositoryMock.updatePuppy(any!, any!))
            .thenAnswer((_) async => Stub.puppiesWithDetails[0]);
        bloc.events.savePuppy();
      },
      expect: [
        Stub.testErr.toString().replaceAll('Exception: ', ''),
        true,
      ],
    );
  });
}

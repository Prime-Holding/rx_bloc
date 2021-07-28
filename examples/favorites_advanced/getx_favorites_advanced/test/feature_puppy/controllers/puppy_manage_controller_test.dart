import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';

import '../../stubs.dart';
import 'puppy_manage_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
Future<void> main() async {
  late MockPuppiesRepository _mockRepo;
  late CoordinatorController _coordinatorController;
  late PuppyManageController _controller;
  late PuppyManageController _controllerNullPuppy;
  final _puppy = Stub.puppiesWithDetails[2];

  setUpAll(() {
    Get.testMode = true;
    _mockRepo = MockPuppiesRepository();
    Get.put<PuppiesRepository>(_mockRepo);
    _coordinatorController = Get.put(CoordinatorController());
    _controllerNullPuppy = Get.put(
        PuppyManageController(_mockRepo, _coordinatorController, puppy: null));
    _controller = Get.put(
        PuppyManageController(_mockRepo, _coordinatorController, puppy: _puppy),
        tag: 'Edit');
  });

  tearDownAll(() {
    Get
      ..delete<PuppiesRepository>()
      ..delete<CoordinatorController>()
      ..delete<PuppyManageController>()
      ..delete<PuppyManageController>(tag: 'edit');
  });

  group('PuppyManageController - ', () {
    group('correct initialization - ', () {
      test('without puppy', () {
        expect(_controllerNullPuppy.name, isEmpty);
        expect(_controllerNullPuppy.characteristics, isEmpty);
        expect(_controllerNullPuppy.gender, Gender.None);
        expect(_controllerNullPuppy.breed, BreedType.None);
        expect(_controllerNullPuppy.asset.value, isEmpty);
      });

      test('with puppy', () {
        expect(_controller.name, _puppy.name);
        expect(_controller.characteristics, _puppy.breedCharacteristics);
        expect(_controller.gender, _puppy.gender);
        expect(_controller.breed, _puppy.breedType);
        expect(_controller.asset.value, _puppy.asset);
        expect(_controller.editedPuppy, _puppy);
      });
    });

    test('markAsFavorite', () async {
      // arrange
      when(_mockRepo.favoritePuppy(Stub.puppyTest, isFavorite: true))
          .thenAnswer((_) async => Stub.puppyTestUpdated);
      // action
      await _controllerNullPuppy.markAsFavorite(
          puppy: Stub.puppyTest, isFavorite: true);
      // assert
      expect(_coordinatorController.puppiesToUpdate,
          <Puppy>[Stub.puppyTestUpdated]);
      /// test below fails with 'Null check operator used on a null value'
      /// when try to call Get.showSnackbar(... in puppy_manage_controller.dart
      // // arrange
      // when(_mockRepo.favoritePuppy(Stub.puppyTest, isFavorite: true))
      //     .thenAnswer((_) async => throw Stub.testErr);
      // // action
      // await _controllerNullPuppy.markAsFavorite(
      //     puppy: Stub.puppyTest, isFavorite: true);
      // final puppiesToUpdate = _coordinatorController.puppiesToUpdate;
      // // assert
      // await expectLater(puppiesToUpdate, <Puppy>[Stub.puppyTest]);
    });

    group('set name - ', () {
      test('with null value', () {
        final validateString = _controller.validateName(null);
        expect(validateString, Stub.nameEmptyErr);
      });

      test('with empty value', () {
        final validateString = _controller.validateName('');
        expect(validateString, Stub.nameEmptyErr);
      });

      test('with too long value', () {
        final validateString = _controller.validateName(Stub.string31);
        expect(validateString, Stub.nameTooLongErr);
      });

      test('with valid value', () {
        final validateString = _controller.validateName('Name');
        expect(validateString, isNull);
      });

      test('local variable', () async {
        const newName = 'Name';
        _controller.changeLocalName(newName);
        expect(_controller.isSaveEnabled(), isTrue);
        expect(_controller.name, newName);
      });

      test('mutate local puppy', () async {
        const newName = 'Name';
        _controller
          ..changeLocalName(newName)
          ..setName(newName);
        expect(_controller.isSaveEnabled(), isTrue);
        expect(_controller.editedPuppy.name, newName);
      });
    });

    group('set characteristics - ', () {
      test('with null value', () {
        final validateString = _controller.validateCharacteristics(null);
        expect(validateString, Stub.characteristicsEmptyErr);
      });

      test('with empty value', () {
        final validateString = _controller.validateCharacteristics('');
        expect(validateString, Stub.characteristicsEmptyErr);
      });

      test('with too long value', () {
        final validateString =
            _controller.validateCharacteristics(Stub.string251);
        expect(validateString, Stub.characteristicsTooLongErr);
      });

      test('with valid value', () {
        final validateString = _controller.validateName('Some random text');
        expect(validateString, isNull);
      });

      test('local variable', () async {
        const newCharacteristics = 'Some random text';
        _controller.changeLocalCharacteristics(newCharacteristics);
        expect(_controller.isSaveEnabled(), isTrue);
        expect(_controller.characteristics, newCharacteristics);
      });

      test('mutate local puppy', () async {
        const newCharacteristics = 'Some random text';
        _controller
          ..changeLocalCharacteristics(newCharacteristics)
          ..setCharacteristics(newCharacteristics);
        expect(_controller.isSaveEnabled(), isTrue);
        expect(
            _controller.editedPuppy.breedCharacteristics, newCharacteristics);
      });
    });

    group('set breed type - ', () {
      setUp(() {
        _controller.onInit();
      });
      test('wit current value', () {
        //action
        _controller.handleBreedChanging(BreedType.GermanShepherd);
        //assert
        expect(_controller.isSaveEnabled(), isFalse);
      });

      test('wit new value', () {
        //action
        _controller.handleBreedChanging(BreedType.CarolinaDog);
        //assert
        expect(_controller.isSaveEnabled(), isTrue);
        expect(_controller.breed, BreedType.CarolinaDog);
        expect(_controller.editedPuppy.breedType, BreedType.CarolinaDog);
      });

      test('correct value after toggle 3 times', () {
        _controller.handleBreedChanging(BreedType.Akita);
        expect(_controller.isSaveEnabled(), isTrue);

        _controller.handleBreedChanging(BreedType.GermanShepherd);
        expect(_controller.isSaveEnabled(), isFalse);

        _controller.handleBreedChanging(BreedType.Beagle);
        expect(_controller.isSaveEnabled(), isTrue);

        expect(_controller.breed, BreedType.Beagle);
        expect(_controller.editedPuppy.breedType, BreedType.Beagle);
      });
    });

    group('set gender type - ', () {
      setUp(() {
        _controller.onInit();
      });
      test('wit current value', () {
        //action
        expect(_controller.isSaveEnabled(), isFalse);

        _controller.handleGenderChanging(Gender.Male);
        //assert
        expect(_controller.gender, Gender.Male);
        expect(_controller.isSaveEnabled(), isFalse);
      });

      test('wit new value', () {
        //action
        _controller.handleGenderChanging(Gender.Female);
        //assert
        expect(_controller.isSaveEnabled(), isTrue);
        expect(_controller.gender, Gender.Female);
        expect(_controller.editedPuppy.gender, Gender.Female);
      });

      test('correct value after toggle 3 times', () {
        _controller.handleGenderChanging(Gender.Female);
        expect(_controller.isSaveEnabled(), isTrue);

        _controller.handleGenderChanging(Gender.Male);
        expect(_controller.isSaveEnabled(), isFalse);

        _controller.handleGenderChanging(Gender.Female);
        expect(_controller.isSaveEnabled(), isTrue);

        expect(_controller.gender, Gender.Female);
        expect(_controller.editedPuppy.gender, Gender.Female);
      });
    });

    group('set puppy image - ', () {
      setUp(() {
        _controller.onInit();
        reset(_mockRepo);
      });
      test('camera image', () async {
        //arrange
        when(_mockRepo.pickPuppyImage(ImagePickerAction.camera))
            .thenAnswer((_) async => PickedFile('camera_image'));
        //action
        await _controller.pickImage(ImagePickerAction.camera);
        //assert
        expect(_controller.editedPuppy.asset, contains('camera'));
      });

      test('gallery image', () async {
        //arrange
        when(_mockRepo.pickPuppyImage(ImagePickerAction.gallery))
            .thenAnswer((_) async => PickedFile('gallery_image'));
        //action
        await _controller.pickImage(ImagePickerAction.gallery);
        //assert
        expect(_controller.asset.value, contains('gallery'));
      });

      test('null image', () async {
        //arrange
        when(_mockRepo.pickPuppyImage(ImagePickerAction.gallery))
            .thenAnswer((_) async => null);
        //action
        await _controller.pickImage(ImagePickerAction.gallery);
        //assert
        expect(_controller.editedPuppy.asset, _puppy.asset);
      });
    });

    group('save puppy', () {
      // setUp(() {
      //   _controller.onInit();
      // });
      test('unsuccessful if has error', () async {
        //arrange
        final newName = Stub.string31;
        _controller
          ..validateName(newName)
          ..changeLocalName(newName)
          ..setName(newName);
        //action
        expect(_controller.hasErrors, isTrue);

        final savePuppyMessage = await _controller.savePuppy();
        //assert
        expect(savePuppyMessage, Stub.invalidValue);
      });

      test('successful with new name', () async {
        //arrange
        const newName = 'PuppyNewName';
        _controller
          ..validateName(newName)
          ..changeLocalName(newName)
          ..setName(newName);
        reset(_mockRepo);
        when(_mockRepo.updatePuppy(_puppy.id, _controller.editedPuppy))
            .thenAnswer((_) async => _puppy.copyWith(name: newName));
        //action
        expect(_controller.hasErrors, isFalse);

        final savePuppyMessage = await _controller.savePuppy();
        //assert
        expect(savePuppyMessage, Stub.successfullySaved);
        expect(_coordinatorController.puppiesToUpdate[0],
            _controller.editedPuppy);
      });

      test('unsuccessful if repo throw', () async {
        //arrange
        const newName = 'PuppyNewName';
        _controller
          ..validateName(newName)
          ..changeLocalName(newName)
          ..setName(newName);
        reset(_mockRepo);
        when(_mockRepo.updatePuppy(_puppy.id, _controller.editedPuppy))
            .thenAnswer((_) async => throw Stub.testErr);
        //action
        expect(_controller.hasErrors, isFalse);
        // final savePuppyMessage =
        await _controller.savePuppy();
        //assert
        // print(savePuppyMessage);
        // expect(savePuppyMessage, contains('internet'));
        expect(_coordinatorController.puppiesToUpdate[0],
            _puppy);
      });
    });
  });
}

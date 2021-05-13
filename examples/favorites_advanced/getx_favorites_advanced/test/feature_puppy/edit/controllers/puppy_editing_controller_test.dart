import 'package:favorites_advanced_base/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/base/controllers/coordinator_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/edit/controllers/puppy_editing_controller.dart';
import 'package:mockito/annotations.dart';

import '../../../stubs.dart';
import 'puppy_editing_controller_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main() {

  late MockPuppiesRepository _mockRepo;
  late CoordinatorController _mediatorController;
  late PuppyEditingController _controller;
  final _puppy = Stub.puppiesWithDetails[2];

  setUp(() {
    Get.testMode = true;
    _mockRepo = MockPuppiesRepository();
    Get.put<PuppiesRepository>(_mockRepo);
    _mediatorController = Get.put(CoordinatorController());
    _controller = Get.put(
        PuppyEditingController(_mockRepo, _mediatorController, _puppy));
  });
  tearDown((){
    Get..delete<MockPuppiesRepository>()
      ..delete<CoordinatorController>()
      ..delete<PuppyEditingController>();
  });

  group('PuppyEditingController - ', (){
    test('correct initialization', () {
      expect(_controller.name, _puppy.name);
      expect(_controller.characteristics, _puppy.breedCharacteristics);
      expect(_controller.gender, _puppy.gender);
      expect(_controller.breed, _puppy.breedType);
      expect(_controller.asset.value, _puppy.asset);
      expect(_controller.editedPuppy, _puppy);
      expect(_controller.nameController.text, _puppy.name);
      expect(_controller.characteristicsController.text,
          _puppy.breedCharacteristics);
    });
    group('set name - ', (){
      test('with null value', (){
        final validateString = _controller.validateName(null);
        expect(validateString, Stub.nameEmptyErr);
      });

      test('with empty value', (){
        final validateString = _controller.validateName('');
        expect(validateString, Stub.nameEmptyErr);
      });

      test('with too long value', (){
        final validateString = _controller.validateName(Stub.string31);
        expect(validateString, Stub.nameTooLongErr);
      });

      test('with valid value', (){
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
        _controller..changeLocalName(newName)
          ..setName(newName);
        expect(_controller.isSaveEnabled(), isTrue);
        expect(_controller.editedPuppy.name, newName);
      });

    });

    group('set characteristics - ', (){
      test('with null value', (){
        final validateString = _controller.validateCharacteristics(null);
        expect(validateString, Stub.characteristicsEmptyErr);
      });

      test('with empty value', (){
        final validateString = _controller.validateCharacteristics('');
        expect(validateString, Stub.characteristicsEmptyErr);
      });

      test('with too long value', (){
        final validateString =
        _controller.validateCharacteristics(Stub.string251);
        expect(validateString, Stub.characteristicsTooLongErr);
      });

      test('with valid value', (){
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
        _controller..changeLocalCharacteristics(newCharacteristics)
          ..setCharacteristics(newCharacteristics);
        expect(_controller.isSaveEnabled(), isTrue);
        expect(_controller.editedPuppy.breedCharacteristics,
            newCharacteristics);
      });
    });
    group('set gender type - ', () {
      test('wit current value', () {
        //action
        _controller.handleGenderChanging(Gender.Male);
        //assert
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

    group('set breed type - ', () {
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

  });
}

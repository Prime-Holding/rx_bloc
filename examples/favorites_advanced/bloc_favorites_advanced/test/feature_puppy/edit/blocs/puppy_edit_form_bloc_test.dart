import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:bloc_sample/feature_puppy/edit/bloc/puppy_edit_form_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as mock;
import 'package:favorites_advanced_base/repositories.dart';
import 'package:favorites_advanced_base/models.dart';

import '../../../stubs.dart';

import 'puppy_edit_form_bloc_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
  CoordinatorBloc,
])
void main() {
  late MockPuppiesRepository mockRepo;
  late MockCoordinatorBloc mockCoordinatorBloc;
  late PuppyEditFormBloc puppyEditFormBloc;
  setUp(() {
    mockRepo = MockPuppiesRepository();
    mockCoordinatorBloc = MockCoordinatorBloc();
    mock
        .when(mockCoordinatorBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    mock
        .when(mockRepo.updatePuppy(
            Stub.isNotFavoritePuppy3.id, Stub.isNotFavoritePuppy3))
        .thenAnswer((_) => Future.value(Stub.isNotFavoritePuppy3));

    puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );
  });

  test('PuppyEditFormBloc onSubmitting', () async {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );

    puppyEditFormBloc.name.updateValue('newValue');
    await Future.delayed(const Duration(milliseconds: 10));
    expect(puppyEditFormBloc.state, isA<FormBlocLoaded>());

    puppyEditFormBloc.submit();
    await Future.delayed(const Duration(milliseconds: 10));
    expect(puppyEditFormBloc.state, isA<FormBlocSubmitting>());

    await Future.delayed(const Duration(milliseconds: 10));
    expect(puppyEditFormBloc.state, isA<FormBlocSuccess>());
  });

  test('PuppyEditFormBloc name bloc', () async {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );
    final bloc = puppyEditFormBloc.name;

    puppyEditFormBloc.name.updateInitialValue(Stub.isNotFavoritePuppy3.name);
    await Future.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.value, Stub.isNotFavoritePuppy3.name);

    bloc.updateValue('Buddy1');
    await Future.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.value, Stub.isNotFavoritePuppy3Edit.name);

    bloc.updateValue('');
    puppyEditFormBloc.submit();
    await Future.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.error, Stub.nameMustNotBeEmpty);

    bloc.updateValue(Stub.string31);
    puppyEditFormBloc.submit();
    await Future.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.error, Stub.nameTooLongError);
  });

  test('PuppyEditFormBloc characteristics bloc', () async {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );
    final bloc = puppyEditFormBloc.characteristics;

    puppyEditFormBloc.characteristics
        .updateInitialValue(Stub.isNotFavoritePuppy3.displayCharacteristics);
    await Future.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.value, Stub.isNotFavoritePuppy3.displayCharacteristics);
    bloc.updateValue('Characteristics Buddy 31');

    await Future.delayed(const Duration(milliseconds: 20));
    expect(
        bloc.state.value, Stub.isNotFavoritePuppy3Edit.displayCharacteristics);

    bloc.updateValue('');
    puppyEditFormBloc.submit();
    await Future.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.error, Stub.characteristicsEmptyErr);

    bloc.updateValue(Stub.string251);
    puppyEditFormBloc.submit();
    await Future.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.error, Stub.characteristicsTooLongErr);
  });

  test('PuppyEditFormBloc breed bloc', () async {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );
    final bloc = puppyEditFormBloc.breed;

    puppyEditFormBloc.breed
        .updateInitialValue(Stub.isNotFavoritePuppy3.breedType);
    await Future.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.value, Stub.isNotFavoritePuppy3.breedType);
    bloc.updateValue(BreedType.GoldenRetriever);

    await Future.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.value, Stub.isNotFavoritePuppy3Edit.breedType);

    bloc.updateValue(BreedType.None);
    await Future.delayed(const Duration(milliseconds: 10));
    await expectLater(puppyEditFormBloc.breedError$,
        emitsInOrder(['', Stub.breedNotSelectedErr]));

    bloc.updateValue(null);
    await Future.delayed(const Duration(milliseconds: 10));

    await expectLater(puppyEditFormBloc.breedError$,
        emitsInOrder(['', Stub.breedNotSelectedErr]));
  });

  test('PuppyEditFormBloc gender bloc', () async {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );
    final bloc = puppyEditFormBloc.gender;

    puppyEditFormBloc.gender
        .updateInitialValue(Stub.isNotFavoritePuppy3.gender);
    await Future.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.value, Stub.isNotFavoritePuppy3.gender);
    bloc.updateValue(Gender.Female);

    await Future.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.value, Stub.isNotFavoritePuppy3Edit.gender);

    bloc.updateValue(Gender.None);
    puppyEditFormBloc.submit();
    await Future.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.error, Stub.emptyGenderFieldError);

    bloc.updateValue(null);
    puppyEditFormBloc.submit();
    await Future.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.error, Stub.emptyGenderFieldError);
  });

  test('PuppyEditFormBloc image bloc', () async {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );
    final bloc = puppyEditFormBloc.image;

    // await Future.delayed(Stub.pickImageDelay);
    // expect(bloc.state.value, null);
    // expect(bloc.value, null);
    mock
        .when(mockRepo.pickPuppyImage(ImagePickerAction.camera))
        .thenAnswer((_) async => PickedFile('camera image'));
    bloc.updateInitialValue(ImagePickerAction.camera);
    await Future.delayed(Stub.pickImageDelay);
    expect(bloc.state.value, ImagePickerAction.camera);

    mock
        .when(mockRepo.pickPuppyImage(ImagePickerAction.gallery))
        .thenAnswer((_) async => PickedFile('gallery image'));
    bloc.updateValue(ImagePickerAction.gallery);
    await Future.delayed(Stub.pickImageDelay);

    expect(bloc.state.value, ImagePickerAction.gallery);
  });

  test('PuppyEditFormBloc asset stream', () {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );

    expectLater(
        puppyEditFormBloc.asset$,
        emitsInOrder([
          Stub.isNotFavoritePuppy3.asset,
        ]));
  });

  test('PuppyEditFormBloc name stream', () async {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );

    final nameBloc = puppyEditFormBloc.name;
    await Future.delayed(const Duration(milliseconds: 10));
    nameBloc.updateValue('NewName');
    await expectLater(
        puppyEditFormBloc.name$,
        emitsInOrder([
          //starts with the name of the puppy passed to the bloc
          Stub.isNotFavoritePuppy3.name,
          //returns the new valid name
          'NewName'
        ]));
  });

  test('PuppyEditFormBloc gender stream', () async {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );
    await Future.delayed(const Duration(milliseconds: 10));

    puppyEditFormBloc.gender.updateValue(Gender.Female);
    await Future.delayed(const Duration(milliseconds: 10));

    await expectLater(
        puppyEditFormBloc.gender$,
        emitsInOrder([
          Stub.isNotFavoritePuppy3.gender,
          Gender.Female,
        ]));
  });

  test('PuppyEditFormBloc characteristics stream', () async {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );
    await Future.delayed(const Duration(milliseconds: 10));

    puppyEditFormBloc.characteristics.updateValue('NewValue');
    await Future.delayed(const Duration(milliseconds: 10));

    await expectLater(
        puppyEditFormBloc.characteristics$,
        emitsInOrder([
          Stub.isNotFavoritePuppy3.displayCharacteristics,
          'NewValue',
        ]));
  });

  test('PuppyEditFormBloc breed stream', () async {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );
    await Future.delayed(const Duration(milliseconds: 10));

    puppyEditFormBloc.breed.updateValue(BreedType.Akita);
    await Future.delayed(const Duration(milliseconds: 10));

    await expectLater(
        puppyEditFormBloc.breed$,
        emitsInOrder([
          Stub.isNotFavoritePuppy3.breedType,
          BreedType.Akita,
        ]));
  });

  test(
      'PuppyEditFormBloc isFormValid stream without change of the value in'
      'other streams', () {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );

    expectLater(puppyEditFormBloc.isFormValid$, emitsInOrder([false, false]));
  });

  test(
      'PuppyEditFormBloc isFormValid stream with a change of the value in'
      'another stream', () async {
    final puppyEditFormBloc = PuppyEditFormBloc(
      coordinatorBloc: mockCoordinatorBloc,
      repository: mockRepo,
      puppy: Stub.isNotFavoritePuppy3,
    );
    final nameBloc = puppyEditFormBloc.name;
    await Future.delayed(const Duration(milliseconds: 10));
    nameBloc.updateValue('NewValue');
    await Future.delayed(const Duration(milliseconds: 10));
    await expectLater(
        puppyEditFormBloc.isFormValid$, emitsInOrder([false, true]));
  });

  test('dispose', () {
    puppyEditFormBloc.dispose();
  });
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:image_picker/image_picker.dart';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:redux_favorite_advanced_sample/base/models/app_state.dart';
import 'package:redux_favorite_advanced_sample/base/redux/app_reducer.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/details/models/details_state.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/edit/redux/actions.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/edit/redux/epics.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/edit/validators/form_validators.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/favorites/models/favorite_list_state.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/redux/epics.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/redux/actions.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/redux/epics.dart';

import '../../stubs.dart';
import 'edit_test.mocks.dart';

@GenerateMocks([
  PuppiesRepository,
])
void main() {
  late MockPuppiesRepository repository;
  late EpicMiddleware<AppState> epicMiddleware;
  late Store<AppState> store;

  final state = AppState.initialState();

  setUp(() {
    repository = MockPuppiesRepository();
    epicMiddleware = EpicMiddleware(
      combineEpics<AppState>([
        fetchPuppiesEpic(repository),
        puppyFavoriteEpic(repository),
        pickImageEpic(repository),
        updatePuppyEpic(repository),
      ]),
    );
    store = Store<AppState>(
      appReducer,
      initialState: AppState.initialState(),
      middleware: [epicMiddleware],
    );
  });

  group('Update Puppy Epic Middleware', () {
    test('Change fields', () {
      scheduleMicrotask(() {
        store
          ..dispatch(EditPuppyAction(puppy: Stub.puppy1))
          ..dispatch(NameAction(name: 'test1'))
          ..dispatch(BreedAction(breedType: BreedType.Akita))
          ..dispatch(GenderAction(gender: Gender.Male))
          ..dispatch(CharacteristicsAction(characteristics: 'test1'));
      });

      expect(
        store.onChange,
        emitsThrough(
          state.copyWith(
            editState: state.editState.copyWith(
              puppy: Stub.puppy1.copyWith(
                name: 'test1',
                breedType: BreedType.Akita,
                gender: Gender.Male,
                breedCharacteristics: 'test1',
              ),
            ),
          ),
        ),
      );
    });

    test('Change image - success', () {
      when(repository.pickPuppyImage(ImagePickerAction.gallery))
          .thenAnswer((_) async => PickedFile('test1'));

      scheduleMicrotask(() {
        store
          ..dispatch(EditPuppyAction(puppy: Stub.puppy1))
          ..dispatch(ImagePickAction(source: ImagePickerAction.gallery));
      });

      expect(
        store.onChange,
        emitsThrough(
          state.copyWith(
            editState: state.editState.copyWith(
              puppy: Stub.puppy1.copyWith(
                asset: 'test1',
              ),
            ),
          ),
        ),
      );
    });

    test('Change image - error', () {
      when(repository.pickPuppyImage(ImagePickerAction.camera))
          .thenAnswer((_) async => throw Stub.testErr);

      scheduleMicrotask(() {
        store
          ..dispatch(EditPuppyAction(puppy: Stub.puppy1))
          ..dispatch(ImagePickAction(source: ImagePickerAction.camera));
      });

      expect(
        store.onChange,
        emitsThrough(
          state.copyWith(
            editState: state.editState.copyWith(
              puppy: Stub.puppy1,
              error: 'Error: Please grant camera permissions.',
            ),
          ),
        ),
      );
    });

    test('Name empty validation error', () {
      scheduleMicrotask(() {
        store.dispatch(
          UpdatePuppyAction(puppy: Stub.puppy1.copyWith(name: '')),
        );
      });

      expect(
        store.onChange,
        emitsThrough(
          state.copyWith(
            editState: state.editState.copyWith(
              nameError: nameEmptyError,
            ),
          ),
        ),
      );
    });

    test('Name too long validation error', () {
      scheduleMicrotask(() {
        store.dispatch(
          UpdatePuppyAction(
            puppy:
                Stub.puppy1.copyWith(name: 'iuinq1nGaj5mfhWANPLqi44P1UmXaP2'),
          ),
        );
      });

      expect(
        store.onChange,
        emitsThrough(
          state.copyWith(
            editState: state.editState.copyWith(
              nameError: nameLengthError,
            ),
          ),
        ),
      );
    });

    test('Characteristics empty validation error', () {
      scheduleMicrotask(() {
        store.dispatch(
          UpdatePuppyAction(
              puppy: Stub.puppy1.copyWith(breedCharacteristics: '')),
        );
      });

      expect(
        store.onChange,
        emitsThrough(
          state.copyWith(
            editState: state.editState.copyWith(
              characteristicsError: characteristicsEmptyError,
            ),
          ),
        ),
      );
    });

    test('Characteristics too long validation error', () {
      scheduleMicrotask(() {
        store.dispatch(
          UpdatePuppyAction(
            puppy: Stub.puppy1.copyWith(
                breedCharacteristics:
                    '''2faqagel1dwIRKsgMgDYXgxWB7svN3nStYH8K7BkHklAyBSwkLgKjriiKy8F7usahF76LDRH8L0ZKz5qEP9lqxalkE9ZKIwf5z0h72Xcm1h3fJZctEhHpLLsD3jyJIEAjHhSFTP7v23nBDN8f6i0ni4qw6uz2WiXAh2reYnQeD8KZEu8kv1B3Ahv4h8HZLNld8chzQpPji5Qbhs895pA5A8SXt1i40evhKCMvsIgLxPsPkTlMO53fwbNmTM'''),
          ),
        );
      });

      expect(
        store.onChange,
        emitsThrough(
          state.copyWith(
            editState: state.editState.copyWith(
              characteristicsError: characteristicsLengthError,
            ),
          ),
        ),
      );
    });

    test('Update success', () {
      when(repository.getPuppies()).thenAnswer((_) async => Stub.puppies123);

      when(repository.favoritePuppy(Stub.puppy1, isFavorite: true))
          .thenAnswer((_) async => Stub.puppy1.copyWith(isFavorite: true));

      when(repository.updatePuppy(
              Stub.puppy1.id, Stub.puppy2.copyWith(id: Stub.puppy1.id)))
          .thenAnswer((_) async => Stub.puppy2.copyWith(id: Stub.puppy1.id));

      scheduleMicrotask(() {
        store
          ..dispatch(PuppiesFetchRequestedAction())
          ..dispatch(
            PuppyToggleFavoriteAction(puppy: Stub.puppy1, isFavorite: true),
          )
          ..dispatch(
            UpdatePuppyAction(puppy: Stub.puppy2.copyWith(id: Stub.puppy1.id)),
          );
      });

      expect(
        store.onChange,
        emitsThrough(
          state.copyWith(
            puppyListState: state.puppyListState.copyWith(
              puppies: [
                Stub.puppy2.copyWith(id: Stub.puppy1.id),
                Stub.puppy2,
                Stub.puppy3,
              ],
            ),
            favoriteListState: FavoriteListState(
              puppies: [
                Stub.puppy2.copyWith(id: Stub.puppy1.id),
              ],
            ),
            detailsState: DetailsState(
              puppy: Stub.puppy2.copyWith(id: Stub.puppy1.id),
            ),
            favoriteCount: 1,
          ),
        ),
      );
    });

    test('Update error', () {
      when(repository.updatePuppy(
              Stub.puppy1.id, Stub.puppy2.copyWith(id: Stub.puppy1.id)))
          .thenAnswer((_) async => throw Stub.testErr);

      scheduleMicrotask(() {
        store.dispatch(
          UpdatePuppyAction(puppy: Stub.puppy2.copyWith(id: Stub.puppy1.id)),
        );
      });

      expect(
        store.onChange,
        emitsThrough(
          state.copyWith(
            editState: state.editState.copyWith(
              error: Stub.testErr.toString(),
            ),
          ),
        ),
      );
    });
  });
}

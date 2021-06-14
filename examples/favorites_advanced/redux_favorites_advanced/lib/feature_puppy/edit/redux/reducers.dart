import 'package:favorites_advanced_base/models.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/edit/validators/form_validators.dart';

import '../models/edit_state.dart';
import 'actions.dart';

EditState editStateReducer(EditState state, action) => EditState(
      isSubmitAttempted: isSubmitAttemptedReducer(
          state: state.isSubmitAttempted, action: action),
      isLoading: isLoadingReducer(state: state.isLoading, action: action),
      isUpdated: isUpdatedReducer(state: state.isUpdated, action: action),
      puppy: editPuppyReducer(state: state.puppy, action: action),
      nameError: nameErrorReducer(state: state.nameError, action: action),
      characteristicsError: characteristicsErrorReducer(
          state: state.characteristicsError, action: action),
      error: errorReducer(state: state.error, action: action),
    );

bool isSubmitAttemptedReducer({required bool state, action}) {
  if (action is SubmitAttemptedAction) return true;
  if (action is EditPuppyAction) return false;
  return state;
}

bool isLoadingReducer({required bool state, action}) {
  if (action is EditLoadingAction) return true;
  if (action is UpdateSucceededAction || action is UpdateErrorAction) {
    return false;
  }
  return state;
}

bool isUpdatedReducer({required bool state, action}) {
  if (action is UpdateSucceededAction) return true;
  return false;
}

Puppy editPuppyReducer({required Puppy state, action}) {
  if (action is EditPuppyAction) {
    return action.puppy;
  }
  if (action is ImagePathAction) {
    return state.copyWith(asset: action.imagePath);
  }
  if (action is NameAction) {
    return state.copyWith(name: action.name);
  }
  if (action is BreedAction) {
    return state.copyWith(breedType: action.breedType);
  }
  if (action is GenderAction) {
    return state.copyWith(gender: action.gender);
  }
  if (action is CharacteristicsAction) {
    return state.copyWith(breedCharacteristics: action.characteristics);
  }
  return state;
}

String nameErrorReducer({required String state, action}) {
  if (action is ValidateNameAction) return nameValidator(action.name);
  return state;
}

String characteristicsErrorReducer({required String state, action}) {
  if (action is ValidateCharacteristicsAction) {
    return characteristicsValidator(action.characteristics);
  }
  return state;
}

String errorReducer({required String state, action}) {
  if (action is UpdateErrorAction) return action.error;
  return '';
}

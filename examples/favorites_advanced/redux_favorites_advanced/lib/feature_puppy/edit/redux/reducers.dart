import 'package:favorites_advanced_base/models.dart';

import '../models/edit_state.dart';
import 'actions.dart';

EditState editStateReducer(EditState state, action) => EditState(
      isSubmitAttempted: isSubmitAttemptedReducer(
          state: state.isSubmitAttempted, action: action),
      isLoading: isLoadingReducer(state: state.isLoading, action: action),
      isUpdated: isUpdatedReducer(state: state.isUpdated, action: action),
      puppy: editPuppyReducer(state: state.puppy, action: action),
      error: errorReducer(state: state.error, action: action),
    );

bool isSubmitAttemptedReducer({required bool state, action}) {
  if (action is SubmitAttemptedAction) return true;
  if (action is EditPuppyAction) return false;
  return state;
}

bool isLoadingReducer({required bool state, action}) {
  if (action is EditLoadingAction) return true;
  if (action is UpdateSucceededAction || action is UpdateFailedAction) {
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

String errorReducer({required String state, action}) {
  if (action is UpdateFailedAction) return action.error;
  return '';
}

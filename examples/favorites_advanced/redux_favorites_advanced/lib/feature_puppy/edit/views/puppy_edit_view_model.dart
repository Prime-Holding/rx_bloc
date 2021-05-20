import 'package:redux/redux.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

import '../../../base/models/app_state.dart';
import '../redux/actions.dart';

class PuppyEditViewModel extends Equatable {
  const PuppyEditViewModel({
    required this.isChanged,
    required this.isSubmitAttempted,
    required this.isLoading,
    required this.isUpdated,
    required this.puppy,
    required this.onImagePicker,
    required this.onNameChange,
    required this.onBreedChange,
    required this.onGenderChange,
    required this.onCharacteristicsChange,
    required this.onSubmit,
    required this.error,
  });

  factory PuppyEditViewModel.from(Store<AppState> store) {
    void _onImagePicker(ImagePickerAction source) {
      store.dispatch(ImagePickAction(source: source));
    }

    void _onNameChange(String name) {
      store.dispatch(NameAction(name: name));
    }

    void _onBreedChange(BreedType breed) {
      store.dispatch(BreedAction(breedType: breed));
    }

    void _onGenderChange(Gender gender) {
      store.dispatch(GenderAction(gender: gender));
    }

    void _onCharacteristicsChange(String characteristics) {
      store.dispatch(CharacteristicsAction(characteristics: characteristics));
    }

    void _onSubmit() {
      store
        ..dispatch(SubmitAttemptedAction())
        ..dispatch(UpdatePuppyAction(puppy: store.state.editState.puppy));
    }

    return PuppyEditViewModel(
      isChanged: store.state.editState.puppy != store.state.detailsState.puppy,
      isSubmitAttempted: store.state.editState.isSubmitAttempted,
      isLoading: store.state.editState.isLoading,
      isUpdated: store.state.editState.isUpdated,
      puppy: store.state.editState.puppy,
      onImagePicker: _onImagePicker,
      onNameChange: _onNameChange,
      onBreedChange: _onBreedChange,
      onGenderChange: _onGenderChange,
      onCharacteristicsChange: _onCharacteristicsChange,
      onSubmit: _onSubmit,
      error: store.state.editState.error,
    );
  }

  final bool isChanged;
  final bool isSubmitAttempted;
  final bool isLoading;
  final bool isUpdated;
  final Puppy puppy;
  final Function(ImagePickerAction) onImagePicker;
  final Function(String) onNameChange;
  final Function(BreedType) onBreedChange;
  final Function(Gender) onGenderChange;
  final Function(String) onCharacteristicsChange;
  final Function() onSubmit;
  final String error;

  @override
  List<Object> get props => [
        isChanged,
        isSubmitAttempted,
        isLoading,
        isUpdated,
        puppy,
        onImagePicker,
        onNameChange,
        onBreedChange,
        onGenderChange,
        onCharacteristicsChange,
        onSubmit,
      ];
}

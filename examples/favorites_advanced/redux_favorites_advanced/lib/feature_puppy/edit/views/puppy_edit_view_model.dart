import 'package:redux/redux.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

import '../../../base/models/app_state.dart';

class PuppyEditViewModel extends Equatable {
  const PuppyEditViewModel({
    required this.isLoading,
    required this.puppy,
    required this.onSubmit,
  });

  factory PuppyEditViewModel.from(Store<AppState> store) {
    void _onSubmit(Puppy puppy) {
      //store.dispatch(ModifyDetailsPuppy(puppy: puppy));
    }

    return PuppyEditViewModel(
      isLoading: store.state.detailsState.isLoading,
      puppy: store.state.detailsState.puppy,
      onSubmit: _onSubmit,
    );
  }

  final bool isLoading;
  final Puppy puppy;
  final Function(Puppy) onSubmit;

  @override
  List<Object> get props => [
        isLoading,
        puppy,
        onSubmit,
      ];
}

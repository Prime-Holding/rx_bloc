import 'package:redux/redux.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

import '../../../base/models/app_state.dart';
import '../../../feature_puppy/edit/redux/actions.dart';
import '../../../feature_puppy/search/redux/actions.dart';

class PuppyDetailsViewModel extends Equatable {
  const PuppyDetailsViewModel({
    required this.puppy,
    required this.onToggleFavorite,
    required this.onEditPuppy,
  });

  factory PuppyDetailsViewModel.from(Store<AppState> store) {
    void _onToggleFavorite(Puppy puppy, bool isFavorite) {
      store.dispatch(PuppyToggleFavoriteAction(
        puppy: puppy,
        isFavorite: isFavorite,
      ));
    }

    void _onEditPuppy(Puppy puppy) {
      store.dispatch(EditPuppyAction(puppy: puppy));
    }

    return PuppyDetailsViewModel(
      puppy: store.state.detailsState.puppy,
      onToggleFavorite: _onToggleFavorite,
      onEditPuppy: _onEditPuppy,
    );
  }

  final Puppy puppy;
  final Function(Puppy, bool) onToggleFavorite;
  final Function(Puppy) onEditPuppy;

  @override
  List<Object> get props => [
        puppy,
        onToggleFavorite,
        onEditPuppy,
      ];
}

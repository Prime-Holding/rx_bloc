import 'package:favorites_advanced_base/models.dart';

import '../models/details_state.dart';
import 'actions.dart';

DetailsState detailsStateReducer(DetailsState state, action) =>
    DetailsState(
      puppy: detailsReducer(state: state.puppy, action: action),
    );

Puppy detailsReducer({required Puppy state, action}) {
  if (action is ModifyDetailsPuppy) {
    return action.puppy;
  }
  return state;
}

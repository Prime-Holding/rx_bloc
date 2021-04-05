import '../../feature_home/redux/reducers.dart';
import '../../feature_puppy/search/redux/reducers.dart';
import '../models/app_state.dart';
import 'actions.dart';

AppState appReducer(AppState state, dynamic action) => state.copyWith(
      navigationState: navStateReducer(state.navigationState, action),
      puppyListState: puppyListStateReducer(state.puppyListState, action),
      favoriteCount: 0,
      error: errorReducer(state.error, action),
    );

String errorReducer(String state, action) {
  if (action is ErrorAction) return action.error;
  return state;
}

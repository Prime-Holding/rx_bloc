import '../../feature_home/redux/reducers.dart';
import '../../feature_puppy/search/redux/reducers.dart';
import '../models/app_state.dart';

AppState appReducer(AppState state, dynamic action) => state.copyWith(
      navigationState: navStateReducer(state.navigationState, action),
      puppyListState: puppyListStateReducer(state.puppyListState, action),
    );

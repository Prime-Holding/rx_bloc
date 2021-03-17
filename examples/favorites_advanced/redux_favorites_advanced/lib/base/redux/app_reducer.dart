import '../../feature_home/redux/reducers.dart';
import '../models/app_state.dart';

AppState appReducer(AppState state, dynamic action) => AppState(
      navigationState: navStateReducer(state.navigationState, action),
    );

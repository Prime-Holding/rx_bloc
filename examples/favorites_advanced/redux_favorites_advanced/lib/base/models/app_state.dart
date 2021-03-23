import 'package:meta/meta.dart';

import '../../feature_home/models/navigation_state.dart';
import '../../feature_puppy/search/models/puppy_list_state.dart';

@immutable
class AppState {
  const AppState({
    required this.navigationState,
    required this.puppyListState,
  });

  factory AppState.initialState() => AppState(
        navigationState: NavigationState.initialState(),
        puppyListState: PuppyListState.initialState(),
      );

  final NavigationState navigationState;
  final PuppyListState puppyListState;

  AppState copyWith(
          {NavigationState? navigationState, PuppyListState? puppyListState}) =>
      AppState(
        navigationState: navigationState ?? this.navigationState,
        puppyListState: puppyListState ?? this.puppyListState,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          navigationState == other.navigationState &&
          puppyListState == other.puppyListState;

  @override
  int get hashCode => navigationState.hashCode ^ puppyListState.hashCode;
}

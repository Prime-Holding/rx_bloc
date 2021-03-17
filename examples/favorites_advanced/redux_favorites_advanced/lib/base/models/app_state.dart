import 'package:meta/meta.dart';

import '../../feature_home/models/navigation_state.dart';

@immutable
class AppState {
  const AppState({@required this.navigationState});

  factory AppState.initialState() => AppState(
        navigationState: NavigationState.initialState(),
      );

  final NavigationState navigationState;

  AppState copyWith({NavigationState navigationState}) => AppState(
        navigationState: navigationState ?? this.navigationState,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState && navigationState == other.navigationState;

  @override
  int get hashCode => navigationState.hashCode;
}

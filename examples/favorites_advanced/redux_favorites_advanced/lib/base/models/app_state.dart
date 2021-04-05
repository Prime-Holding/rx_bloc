import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../feature_home/models/navigation_state.dart';
import '../../feature_puppy/search/models/puppy_list_state.dart';

@immutable
class AppState extends Equatable {
  const AppState({
    required this.navigationState,
    required this.puppyListState,
    required this.favoriteCount,
    required this.error,
  });

  factory AppState.initialState() => AppState(
        navigationState: NavigationState.initialState(),
        puppyListState: PuppyListState.initialState(),
        favoriteCount: 0,
        error: '',
      );

  final NavigationState navigationState;
  final PuppyListState puppyListState;
  final int favoriteCount;
  final String error;

  AppState copyWith(
          {NavigationState? navigationState,
          PuppyListState? puppyListState,
          int? favoriteCount,
          String? error}) =>
      AppState(
        navigationState: navigationState ?? this.navigationState,
        puppyListState: puppyListState ?? this.puppyListState,
        favoriteCount: favoriteCount ?? this.favoriteCount,
        error: error ?? this.error,
      );

  @override
  List<Object> get props =>
      [navigationState, puppyListState, favoriteCount, error];
}

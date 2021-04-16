import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class FavoriteListState extends Equatable {
  const FavoriteListState({
    required this.isError,
    required this.puppies,
  });

  FavoriteListState.initialState()
      : isError = false,
        puppies = [];

  final bool isError;
  final List<Puppy> puppies;

  FavoriteListState copyWith({
    bool? isError,
    List<Puppy>? puppies,
  }) =>
      FavoriteListState(
        isError: isError ?? this.isError,
        puppies: puppies ?? this.puppies,
      );

  @override
  List<Object> get props => [isError, puppies];
}

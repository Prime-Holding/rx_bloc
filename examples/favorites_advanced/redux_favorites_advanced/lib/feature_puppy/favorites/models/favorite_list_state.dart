import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class FavoriteListState extends Equatable {
  const FavoriteListState({
    required this.puppies,
  });

  FavoriteListState.initialState() : puppies = [];

  final List<Puppy> puppies;

  FavoriteListState copyWith({
    List<Puppy>? puppies,
  }) =>
      FavoriteListState(
        puppies: puppies ?? this.puppies,
      );

  @override
  List<Object> get props => [puppies];
}

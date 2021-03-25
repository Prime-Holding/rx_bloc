import 'package:flutter/foundation.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class PuppyListState {
  const PuppyListState({
    this.isError,
    this.puppies,
  });

  PuppyListState.initialState()
      : isError = false,
        puppies = [];

  final bool? isError;
  final List<Puppy>? puppies;

  PuppyListState copyWith({
    required bool? isError,
    required List<Puppy>? puppies,
  }) =>
      PuppyListState(
        isError: isError ?? this.isError,
        puppies: puppies ?? this.puppies,
      );
}

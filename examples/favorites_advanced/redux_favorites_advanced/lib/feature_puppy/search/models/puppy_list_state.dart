import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class PuppyListState extends Equatable {
  const PuppyListState({
    required this.isError,
    required this.puppies,
  });

  PuppyListState.initialState()
      : isError = false,
        puppies = [];

  final bool isError;
  final List<Puppy> puppies;

  PuppyListState copyWith({
    bool? isError,
    List<Puppy>? puppies,
  }) =>
      PuppyListState(
        isError: isError ?? this.isError,
        puppies: puppies ?? this.puppies,
      );

  @override
  List<Object> get props => [isError, puppies];
}

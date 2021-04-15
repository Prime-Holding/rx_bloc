import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class PuppyListState extends Equatable {
  const PuppyListState({
    required this.isLoading,
    required this.isError,
    required this.puppies,
  });

  PuppyListState.initialState()
      : isLoading = false,
        isError = false,
        puppies = [];

  final bool isLoading;
  final bool isError;
  final List<Puppy> puppies;

  PuppyListState copyWith({
    bool? isLoading,
    bool? isError,
    List<Puppy>? puppies,
  }) =>
      PuppyListState(
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        puppies: puppies ?? this.puppies,
      );

  @override
  List<Object> get props => [isLoading, isError, puppies];
}

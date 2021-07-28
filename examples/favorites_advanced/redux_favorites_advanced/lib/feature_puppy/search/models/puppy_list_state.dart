import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class PuppyListState extends Equatable {
  const PuppyListState({
    required this.isLoading,
    required this.isError,
    required this.searchQuery,
    required this.puppies,
  });

  factory PuppyListState.initialState() => const PuppyListState(
        isLoading: false,
        isError: false,
        searchQuery: '',
        puppies: [],
      );

  final bool isLoading;
  final bool isError;
  final String searchQuery;
  final List<Puppy> puppies;

  PuppyListState copyWith({
    bool? isLoading,
    bool? isError,
    String? searchQuery,
    List<Puppy>? puppies,
  }) =>
      PuppyListState(
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        searchQuery: searchQuery ?? this.searchQuery,
        puppies: puppies ?? this.puppies,
      );

  @override
  List<Object> get props => [isLoading, isError, searchQuery, puppies];
}

import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class PuppyListState extends Equatable {
  const PuppyListState({
    required this.isError,
    //required this.errorMessage,
    required this.puppies,
  });

  PuppyListState.initialState()
      : isError = false,
        //errorMessage = '',
        puppies = [];

  final bool isError;
  //final String errorMessage;
  final List<Puppy> puppies;

  PuppyListState copyWith({
    bool? isError,
    String? errorMessage,
    List<Puppy>? puppies,
  }) =>
      PuppyListState(
        isError: isError ?? this.isError,
        //errorMessage: errorMessage ?? this.errorMessage,
        puppies: puppies ?? this.puppies,
      );

  @override
  List<Object> get props => [isError, puppies];
  //List<Object> get props => [isError, errorMessage, puppies];
}

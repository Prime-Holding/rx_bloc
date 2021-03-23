import 'package:flutter/foundation.dart';
//import 'package:image_picker/image_picker.dart';

//import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
//import 'package:favorites_advanced_base/repositories.dart';

@immutable
class PuppyListState {
  const PuppyListState({
    //this.isError,
    this.isLoading,
    this.puppies,
  });

  PuppyListState.initialState()
      : //isError = false,
        isLoading = false,
        puppies = [];

  //final bool isError;
  final bool? isLoading;
  final List<Puppy>? puppies;

  PuppyListState copyWith({
    //@required bool isError,
    required bool? isLoading,
    required List<Puppy>? puppies,
  }) =>
      PuppyListState(
        //isError: isError ?? this.isError,
        isLoading: isLoading ?? this.isLoading,
        puppies: puppies ?? this.puppies,
      );
}

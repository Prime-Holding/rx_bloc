import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class EditState extends Equatable {
  const EditState({
    required this.isSubmitAttempted,
    required this.isLoading,
    required this.isUpdated,
    required this.puppy,
    required this.error,
  });

  factory EditState.initialState() => EditState(
        isSubmitAttempted: false,
        isLoading: false,
        isUpdated: false,
        puppy: Puppy(asset: '', id: '', name: ''),
        error: '',
      );

  final bool isSubmitAttempted;
  final bool isLoading;
  final bool isUpdated;
  final Puppy puppy;
  final String error;

  // EditState copyWith({
  //   bool? isLoading,
  //   Puppy? puppy,
  // }) =>
  //     EditState(
  //       isLoading: isLoading ?? this.isLoading,
  //       puppy: puppy ?? this.puppy,
  //     );

  @override
  List<Object> get props => [
        isSubmitAttempted,
        isLoading,
        isUpdated,
        puppy,
        error,
      ];
}

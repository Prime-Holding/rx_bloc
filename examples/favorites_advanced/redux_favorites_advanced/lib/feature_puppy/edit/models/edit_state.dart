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

  EditState copyWith({
    bool? isSubmitAttempted,
    bool? isLoading,
    bool? isUpdated,
    Puppy? puppy,
    String? error,
  }) =>
      EditState(
        isSubmitAttempted: isSubmitAttempted ?? this.isSubmitAttempted,
        isLoading: isLoading ?? this.isLoading,
        isUpdated: isUpdated ?? this.isUpdated,
        puppy: puppy ?? this.puppy,
        error: error ?? this.error,
      );

  @override
  List<Object> get props => [
        isSubmitAttempted,
        isLoading,
        isUpdated,
        puppy,
        error,
      ];
}

import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class DetailsState extends Equatable {
  const DetailsState({
    required this.isLoading,
    required this.puppy,
  });

  factory DetailsState.initialState() => DetailsState(
        isLoading: false,
        puppy: Puppy(asset: '', id: '', name: ''),
      );

  final bool isLoading;
  final Puppy puppy;

  DetailsState copyWith({
    bool? isLoading,
    Puppy? puppy,
  }) =>
      DetailsState(
        isLoading: isLoading ?? this.isLoading,
        puppy: puppy ?? this.puppy,
      );

  @override
  List<Object> get props => [isLoading, puppy];
}

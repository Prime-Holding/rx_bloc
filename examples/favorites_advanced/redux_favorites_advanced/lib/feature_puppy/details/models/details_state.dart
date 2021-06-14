import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class DetailsState extends Equatable {
  const DetailsState({
    required this.puppy,
  });

  DetailsState.initialState() : puppy = Puppy(asset: '', id: '', name: '');

  final Puppy puppy;

  @override
  List<Object> get props => [puppy];
}

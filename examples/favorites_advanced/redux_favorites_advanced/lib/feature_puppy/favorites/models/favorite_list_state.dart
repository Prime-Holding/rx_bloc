import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class FavoriteListState extends Equatable {
  const FavoriteListState({
    required this.puppies,
  });

  factory FavoriteListState.initialState() =>
      const FavoriteListState(puppies: []);

  final List<Puppy> puppies;

  @override
  List<Object> get props => [puppies];
}

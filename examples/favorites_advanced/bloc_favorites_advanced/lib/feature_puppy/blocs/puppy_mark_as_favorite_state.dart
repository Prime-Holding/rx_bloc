part of 'puppy_mark_as_favorite_bloc.dart';

@immutable
class PuppyMarkAsFavoriteState extends Equatable {
  const PuppyMarkAsFavoriteState({
    this.puppy,
    this.error,
  });

  final Puppy? puppy;
  final String? error;

  PuppyMarkAsFavoriteState copyWith({
    Puppy? puppy,
    String? error,
  }) =>
      PuppyMarkAsFavoriteState(
        puppy: puppy,
        error: error,
      );

  @override
  List<Object?> get props => [puppy, error];
}

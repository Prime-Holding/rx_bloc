part of 'favorite_puppies_bloc.dart';

@immutable
abstract class FavoritePuppiesEvent {}

class MarkAsFavoriteEvent extends FavoritePuppiesEvent {
  MarkAsFavoriteEvent({required this.puppy, required this.isFavorite});

  final Puppy puppy;
  final bool isFavorite;
}

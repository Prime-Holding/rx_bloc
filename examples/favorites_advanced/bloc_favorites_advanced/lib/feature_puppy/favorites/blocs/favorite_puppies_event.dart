part of 'favorite_puppies_bloc.dart';

@immutable
abstract class FavoritePuppiesEvent {}

class FavoritePuppiesFetchEvent extends FavoritePuppiesEvent {}

class FavoritePuppiesMarkAsFavoriteEvent extends FavoritePuppiesEvent {
  FavoritePuppiesMarkAsFavoriteEvent({
    required this.puppy,
    required this.isFavorite,
    required this.updateException,
  });

  final Puppy puppy;
  final bool isFavorite;
  final String updateException;
}
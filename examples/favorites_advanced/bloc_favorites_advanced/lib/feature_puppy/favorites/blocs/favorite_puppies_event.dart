part of 'favorite_puppies_bloc.dart';

@immutable
abstract class FavoritePuppiesEvent {}

class FavoritePuppiesFetchEvent extends FavoritePuppiesEvent {}

class FavoritePuppiesMarkAsFavoriteEvent extends FavoritePuppiesEvent {
  FavoritePuppiesMarkAsFavoriteEvent({
    required this.puppy,
    required this.isFavorite,
  });

  final Puppy puppy;
  final bool isFavorite;
}

// class FavoritePuppiesUpdatedEvent extends FavoritePuppiesEvent {
//   FavoritePuppiesUpdatedEvent({
//     required this.puppies,
//   });
//
//   final List<Puppy> puppies;
// }

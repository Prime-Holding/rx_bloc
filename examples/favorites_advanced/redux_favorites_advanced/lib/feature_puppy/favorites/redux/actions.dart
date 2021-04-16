import 'package:favorites_advanced_base/models.dart';

class AddPuppyToFavoritesListAction {
  AddPuppyToFavoritesListAction({required this.puppy});

  final Puppy puppy;
}

class RemovePuppyFromFavoritesListAction {
  RemovePuppyFromFavoritesListAction({required this.puppy});

  final Puppy puppy;
}

// class PuppiesFetchFailedAction {}

// class PuppyToggleFavoriteAction {
//   PuppyToggleFavoriteAction({required this.puppy, required this.isFavorite});
//
//   final Puppy puppy;
//   final bool isFavorite;
// }
//
// class PuppyFavoriteSucceededAction {
//   PuppyFavoriteSucceededAction({required this.puppy});
//
//   final Puppy puppy;
// }

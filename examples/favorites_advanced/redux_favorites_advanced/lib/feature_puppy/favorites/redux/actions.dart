import 'package:favorites_advanced_base/models.dart';

class PuppyToFavoritesListAction {
  PuppyToFavoritesListAction({required this.puppy});

  final Puppy puppy;
}

class UpdateFavoritesStatePuppyAction {
  UpdateFavoritesStatePuppyAction({required this.puppy});

  final Puppy puppy;
}

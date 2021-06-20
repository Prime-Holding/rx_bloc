import 'package:favorites_advanced_base/models.dart';

class PuppiesFetchRequestedAction {
  PuppiesFetchRequestedAction({this.query});

  final String? query;
}

class PuppiesFetchSucceededAction {
  PuppiesFetchSucceededAction({required this.puppies});

  final List<Puppy> puppies;
}

class PuppiesFetchFailedAction {}

class PuppiesFetchLoadingAction {}

class ExtraDetailsFetchRequestedAction {
  ExtraDetailsFetchRequestedAction({required this.puppy});

  final Puppy puppy;
}

class ExtraDetailsFetchSucceededAction {
  ExtraDetailsFetchSucceededAction({required this.puppies});

  final List<Puppy> puppies;
}

class PuppyToggleFavoriteAction {
  PuppyToggleFavoriteAction({required this.puppy, required this.isFavorite});

  final Puppy puppy;
  final bool isFavorite;
}

class PuppyFavoriteSucceededAction {
  PuppyFavoriteSucceededAction({required this.puppy});

  final Puppy puppy;
}

class UpdateSearchStatePuppyAction {
  UpdateSearchStatePuppyAction({required this.puppy});

  final Puppy puppy;
}

class SearchAction {
  SearchAction({this.query});

  final String? query;
}

class SaveSearchQueryAction {
  SaveSearchQueryAction({this.query});

  final String? query;
}

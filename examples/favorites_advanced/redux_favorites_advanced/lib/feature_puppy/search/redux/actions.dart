import 'package:meta/meta.dart';
import 'package:favorites_advanced_base/models.dart';

class PuppiesFetchRequestedAction {}

class PuppiesFetchSucceededAction {
  PuppiesFetchSucceededAction({required this.puppies});

  final List<Puppy>? puppies;
}

class PuppiesFetchFailedAction {
  PuppiesFetchFailedAction({required this.message});

  final String? message;
}

class ExtraDetailsFetchRequestedAction {
  ExtraDetailsFetchRequestedAction({required this.puppy});

  final Puppy puppy;
}

class ExtraDetailsFetchSucceededAction {
  ExtraDetailsFetchSucceededAction({required this.puppy});

  final Puppy? puppy;
}

class ExtraDetailsFetchFailedAction {
  ExtraDetailsFetchFailedAction({required this.message});

  final String message;
}

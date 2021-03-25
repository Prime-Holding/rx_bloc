import 'package:favorites_advanced_base/models.dart';

class PuppiesFetchRequestedAction {}

class PuppiesFetchSucceededAction {
  PuppiesFetchSucceededAction({required this.puppies});

  final List<Puppy>? puppies;
}

class PuppiesFetchFailedAction {}

class ExtraDetailsFetchRequestedAction {
  ExtraDetailsFetchRequestedAction({required this.puppy});

  final Puppy puppy;
}

class ExtraDetailsFetchSucceededAction {
  ExtraDetailsFetchSucceededAction({required this.puppies});

  final List<Puppy>? puppies;
}

// class ExtraDetailsFetchFailedAction {
//   ExtraDetailsFetchFailedAction({required this.message});
//
//   final String message;
// }

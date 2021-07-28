part of 'puppy_details_bloc.dart';

@immutable
abstract class PuppyDetailsEvent {}

class PuppyDetailsFavoriteEvent extends PuppyDetailsEvent {
  PuppyDetailsFavoriteEvent({
    required this.puppy,
    required this.updateException,
  });

  final Puppy puppy;
  final String updateException;
}

class PuppyDetailsMarkAsFavoriteEvent extends PuppyDetailsEvent {
  PuppyDetailsMarkAsFavoriteEvent({
    required this.puppies,
  });

  final List<Puppy> puppies;
}

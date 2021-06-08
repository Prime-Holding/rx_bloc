part of 'coordinator_bloc.dart';

@immutable
abstract class CoordinatorEvent extends Equatable {}

class CoordinatorPuppyUpdatedEvent extends CoordinatorEvent {
  CoordinatorPuppyUpdatedEvent(this.puppy);

  final Puppy puppy;

  @override
  List<Object?> get props => [puppy];
}

class CoordinatorPuppiesUpdatedEvent extends CoordinatorEvent {
  CoordinatorPuppiesUpdatedEvent(this.puppies);

  final List<Puppy> puppies;

  @override
  List<Object?> get props => [puppies];
}

class CoordinatorFavoritePuppyUpdatedEvent extends CoordinatorEvent {
  CoordinatorFavoritePuppyUpdatedEvent({
    required this.favoritePuppy,
    required this.updateException,
  });

  final Puppy favoritePuppy;
  final String updateException;

  @override
  List<Object?> get props => [favoritePuppy, updateException];
}

class CoordinatorPuppiesWithExtraDetailsEvent extends CoordinatorEvent {
  CoordinatorPuppiesWithExtraDetailsEvent(this.puppies);

  final List<Puppy> puppies;

  @override
  List<Object?> get props => [puppies];
}

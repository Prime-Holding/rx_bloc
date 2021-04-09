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

class CoordinatorPuppiesWithExtraDetailsEvent extends CoordinatorEvent {
  CoordinatorPuppiesWithExtraDetailsEvent(this.puppies);

  final List<Puppy> puppies;

  @override
  List<Object?> get props => [puppies];
}

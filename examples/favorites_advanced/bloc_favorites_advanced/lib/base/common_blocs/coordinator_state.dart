part of 'coordinator_bloc.dart';

@immutable
abstract class CoordinatorState extends Equatable {}

class CoordinatorInitialState extends CoordinatorState {
  @override
  List<Object?> get props => [];
}

class CoordinatorOnPuppyUpdatedState extends CoordinatorState {
  CoordinatorOnPuppyUpdatedState(this.puppy);

  final Puppy puppy;

  @override
  List<Object?> get props => [puppy];
}

class CoordinatorPuppiesUpdatedState extends CoordinatorState {
  CoordinatorPuppiesUpdatedState(this.puppies);

  final List<Puppy> puppies;

  @override
  List<Object?> get props => [puppies];
}

class CoordinatorPuppiesWithExtraDetailsState extends CoordinatorState {
  CoordinatorPuppiesWithExtraDetailsState(this.puppies);

  final List<Puppy> puppies;

  @override
  List<Object?> get props => [puppies];
}

part of 'puppies_extra_details_bloc.dart';

@immutable
abstract class PuppiesExtraDetailsEvent {}

class FetchPuppyExtraDetailsEvent extends PuppiesExtraDetailsEvent {
  FetchPuppyExtraDetailsEvent(this.puppy);

  final Puppy puppy;
}

class FetchPuppiesExtraDetailsEvent extends PuppiesExtraDetailsEvent {
  FetchPuppiesExtraDetailsEvent(this.puppies);

  final List<Puppy> puppies;
}

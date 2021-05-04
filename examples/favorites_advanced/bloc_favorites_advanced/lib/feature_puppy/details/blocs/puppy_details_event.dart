part of 'puppy_details_bloc.dart';

@immutable
class PuppyDetailsEvent {
  const PuppyDetailsEvent({required this.puppy});

  final Puppy puppy;
}

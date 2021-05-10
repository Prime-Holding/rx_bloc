part of 'puppy_details_bloc.dart';

@immutable
class PuppyDetailsEvent {
  const PuppyDetailsEvent({
    required this.puppy,
    required this.updateException,
  });

  final Puppy puppy;
  final String updateException;
}

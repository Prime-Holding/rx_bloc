part of 'puppy_details_bloc.dart';

@immutable
class PuppyDetailsState extends Equatable {
  const PuppyDetailsState({required this.puppy});

  final Puppy puppy;

  @override
  List<Object?> get props => [puppy];

  PuppyDetailsState copyWith({required Puppy puppy}) =>
      PuppyDetailsState(puppy: puppy);
}

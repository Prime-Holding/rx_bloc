part of 'puppy_manage_bloc.dart';

@immutable
class PuppyManageState extends Equatable {
  const PuppyManageState({this.puppy, this.error});

  final Puppy? puppy;
  final String? error;

  PuppyManageState copyWith({
    Puppy? puppy,
    String? error,
  }) =>
      PuppyManageState(
        puppy: puppy,
        error: error,
      );

  @override
  List<Object?> get props => [puppy, error];
}

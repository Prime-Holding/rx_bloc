part of 'puppy_manage_bloc.dart';

@immutable
class PuppyManageState extends Equatable {
  const PuppyManageState({this.puppy, this.error,this.updateComplete,});

  final Puppy? puppy;
  final String? error;
  final bool? updateComplete;

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

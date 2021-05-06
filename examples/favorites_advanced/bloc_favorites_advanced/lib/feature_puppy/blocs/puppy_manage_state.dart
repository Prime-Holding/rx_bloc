part of 'puppy_manage_bloc.dart';

@immutable
class PuppyManageState extends Equatable {
   const PuppyManageState({this.puppy});

  final Puppy? puppy;

  PuppyManageState copyWith({
    required Puppy puppy,
  }) =>
      PuppyManageState(
        puppy: puppy,
      );

  @override
  List<Object?> get props => [puppy];
// PuppyManageState copyWith({
//   List<Puppy>? favoritePuppies,
//   String? error,
// }) =>
//     PuppyManageState(
//       favoritePuppies: favoritePuppies ?? this.favoritePuppies,
//       error: error,
//     );
}

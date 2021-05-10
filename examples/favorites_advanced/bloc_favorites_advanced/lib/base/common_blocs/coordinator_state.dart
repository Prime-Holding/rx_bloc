part of 'coordinator_bloc.dart';

@immutable
abstract class CoordinatorState {}

class CoordinatorInitialState extends CoordinatorState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoordinatorInitialState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

// class CoordinatorOnPuppyUpdatedState extends CoordinatorState {
//   CoordinatorOnPuppyUpdatedState(this.puppy);
//
//   final Puppy puppy;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is CoordinatorOnPuppyUpdatedState &&
//           runtimeType == other.runtimeType &&
//           puppy == other.puppy;
//
//   @override
//   int get hashCode => puppy.hashCode;
// }

class CoordinatorPuppiesUpdatedState extends CoordinatorState {
  CoordinatorPuppiesUpdatedState(this.puppies);

  final List<Puppy> puppies;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoordinatorPuppiesUpdatedState &&
          runtimeType == other.runtimeType &&
          puppies == other.puppies;

  @override
  int get hashCode => puppies.hashCode;
}

class CoordinatorFavoritePuppyUpdatedState extends CoordinatorState {
  CoordinatorFavoritePuppyUpdatedState({
    required this.favoritePuppy,
    required this.updateException,
  });

  final Puppy favoritePuppy;
  final String updateException;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoordinatorFavoritePuppyUpdatedState &&
          runtimeType == other.runtimeType &&
          favoritePuppy == other.favoritePuppy &&
          updateException == other.updateException;

  @override
  int get hashCode => favoritePuppy.hashCode ^ updateException.hashCode;
}

// class CoordinatorPuppiesWithExtraDetailsState extends CoordinatorState {
//   CoordinatorPuppiesWithExtraDetailsState(this.puppies);
//
//   final List<Puppy> puppies;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is CoordinatorPuppiesWithExtraDetailsState &&
//           runtimeType == other.runtimeType &&
//           puppies == other.puppies;
//
//   @override
//   int get hashCode => puppies.hashCode;
// }

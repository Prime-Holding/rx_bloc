part of 'puppy_list_bloc.dart';

enum PuppyListStatus { loading, reloading, success, failure }

@immutable
class PuppyListState {
  const PuppyListState({
    required this.status,
    this.searchedPuppies,
  });

  const PuppyListState.reloadInProgress(
      {required List<Puppy> searchedPuppies, PuppyListStatus? status})
      : this(searchedPuppies: searchedPuppies, status: status);

  const PuppyListState.extraDetailsLoadSuccess(
      {required List<Puppy> searchedPuppies, PuppyListStatus? status})
      : this(searchedPuppies: searchedPuppies, status: status);

  final List<Puppy>? searchedPuppies;
  final PuppyListStatus? status;

  PuppyListState copyWith({
    List<Puppy>? searchedPuppies,
    PuppyListStatus? status,
  }) =>
      PuppyListState(
        searchedPuppies: searchedPuppies ?? this.searchedPuppies,
        status: status ?? this.status,
      );
}

part of 'puppy_list_bloc.dart';

enum PuppyListStatus { initial, reloading, success, failure, allFetched }

@immutable
class PuppyListState {
  const PuppyListState({
    required this.searchedPuppies,
    this.status = PuppyListStatus.initial,
  });

  factory PuppyListState.withInitial() => const PuppyListState(
        searchedPuppies: [],
        status: PuppyListStatus.initial,
      );

  final List<Puppy>? searchedPuppies;
  final PuppyListStatus? status;

  List<Puppy>? get searchedPuppiesList => searchedPuppies;

  PuppyListState copyWith({
    List<Puppy>? searchedPuppies,
    PuppyListStatus? status,
  }) =>
      PuppyListState(
        searchedPuppies: searchedPuppies ?? this.searchedPuppies,
        status: status ?? this.status,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PuppyListState &&
          runtimeType == other.runtimeType &&
          searchedPuppies == other.searchedPuppies &&
          status == other.status;

  @override
  int get hashCode => searchedPuppies.hashCode ^ status.hashCode;
}

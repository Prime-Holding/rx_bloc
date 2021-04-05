part of 'puppy_list_bloc.dart';

enum PuppyListStatus { initial, reloading, success, failure, allFetched }

@immutable
class PuppyListState {
  const PuppyListState({
    required this.searchedPuppies,
    // required this.filtered,
    this.status = PuppyListStatus.initial,
  });

  final List<Puppy>? searchedPuppies;
  final PuppyListStatus? status;

  // final List<Puppy>? filtered;

  List<Puppy>? get searchedPuppiesList => searchedPuppies;

  PuppyListState copyWith({
    List<Puppy>? searchedPuppies,
    PuppyListStatus? status,
    // List<Puppy>? filtered,
  }) =>
      PuppyListState(
        searchedPuppies: searchedPuppies ?? this.searchedPuppies,
        status: status ?? this.status,
        // filtered: filtered ?? this.filtered,
      );

  // @override
// TODO: implement props
//   List<Object?> get props => [searchedPuppies];
}

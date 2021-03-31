part of 'puppy_list_bloc.dart';

enum PuppyListStatus { initial, reloading, success, failure , allFetched}

@immutable
class PuppyListState {
    PuppyListState({
    required this.searchedPuppies,
    this.status = PuppyListStatus.initial,
  });

  final List<Puppy>? searchedPuppies;
   PuppyListStatus? status;

  List<Puppy>? get searchedPuppiesList => searchedPuppies;

  PuppyListState copyWith({
    List<Puppy>? searchedPuppies,
    PuppyListStatus? status,
  }) =>
      PuppyListState(
        searchedPuppies: searchedPuppies ?? this.searchedPuppies,
        status: status ?? this.status,
      );

  // @override
  // // TODO: implement props
  // List<Object?> get props => [searchedPuppies,status];


}

part of 'puppy_list_bloc.dart';

enum PuppyListStatus { initial, reloading, success, failure }

@immutable
class PuppyListState {
  const PuppyListState({
    required this.searchedPuppies,
    this.status = PuppyListStatus.initial,
  });

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
}

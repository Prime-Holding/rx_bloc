part of 'puppy_list_bloc.dart';

enum PuppyListStatus { loading, success, failure }

@immutable
class PuppyListState {
  const PuppyListState({
    @required this.status ,
     this.searchedPuppies,

  });

  final List<Puppy> searchedPuppies;
  final PuppyListStatus status;

  PuppyListState copyWith({
    List<Puppy> searchedPuppies,
    PuppyListStatus status,
  }) => PuppyListState(
      searchedPuppies: searchedPuppies ?? this.searchedPuppies,
      status: status ?? this.status,
    );
}

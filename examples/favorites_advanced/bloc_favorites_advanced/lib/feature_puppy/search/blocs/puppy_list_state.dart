part of 'puppy_list_bloc.dart';

@immutable
class PuppyListState {
  const PuppyListState({
    @required this.searchedPuppies,
  });

  final List<Puppy> searchedPuppies;
}

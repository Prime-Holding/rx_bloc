part of 'puppy_list_bloc.dart';

@immutable
abstract class PuppyListEvent {}

class ReloadFavoritePuppies extends PuppyListEvent{
  ReloadFavoritePuppies({this.silently});

  final bool silently;
}
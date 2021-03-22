part of 'puppy_list_bloc.dart';

@immutable
abstract class PuppyListEvent {}

class ReloadPuppiesEvent extends PuppyListEvent {
  ReloadPuppiesEvent({this.silently});

  final bool silently;
}

class LoadPuppyListEvent extends PuppyListEvent {
  LoadPuppyListEvent();
}

class PuppyFetchDetailsEvent extends PuppyListEvent {
  PuppyFetchDetailsEvent({this.puppy});

  final Puppy puppy;
}

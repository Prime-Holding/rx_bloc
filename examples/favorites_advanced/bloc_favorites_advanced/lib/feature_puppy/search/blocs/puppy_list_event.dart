part of 'puppy_list_bloc.dart';

@immutable
abstract class PuppyListEvent {}

class ReloadPuppiesEvent extends PuppyListEvent {
  ReloadPuppiesEvent();
}

class LoadPuppyListEvent extends PuppyListEvent {
  LoadPuppyListEvent();
}

class PuppyFetchExtraDetailsEvent extends PuppyListEvent {
  PuppyFetchExtraDetailsEvent({this.puppy});

  final Puppy? puppy;
}

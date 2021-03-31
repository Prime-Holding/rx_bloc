part of 'puppy_list_bloc.dart';

@immutable
abstract class PuppyListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

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

class PuppyListFetchExtraDetailsEvent extends PuppyListEvent {
  PuppyListFetchExtraDetailsEvent({required this.puppyList});

  final List<Puppy> puppyList ;
}

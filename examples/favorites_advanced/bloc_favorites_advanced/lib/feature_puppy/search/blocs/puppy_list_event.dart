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

class FavoritePuppiesUpdatedEvent extends PuppyListEvent {
  FavoritePuppiesUpdatedEvent({
    required this.favoritePuppies,
  });

  final List<Puppy> favoritePuppies;

  @override
  List<Object?> get props => [favoritePuppies];
}

part of 'puppy_mark_as_favorite_bloc.dart';

@immutable
abstract class PuppyManageEvent {}

class PuppyMarkAsFavoriteEvent extends PuppyManageEvent {
  PuppyMarkAsFavoriteEvent({
    required this.puppy,
    required this.isFavorite,
  });

  final Puppy puppy;
  final bool isFavorite;
}

// class PuppyManageSavePuppyEvent extends PuppyManageEvent{
//   PuppyManageSavePuppyEvent();
// }
//
// class PuppyManageSetImageEvent extends PuppyManageEvent {
//   PuppyManageSetImageEvent(this.source);
//   final ImagePickerAction source;
// }
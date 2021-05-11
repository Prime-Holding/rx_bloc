part of 'puppy_manage_bloc.dart';

@immutable
abstract class PuppyManageEvent {}

class PuppyManageMarkAsFavoriteEvent extends PuppyManageEvent {
  PuppyManageMarkAsFavoriteEvent({
    required this.puppy,
    required this.isFavorite,
  });

  final Puppy puppy;
  final bool isFavorite;
}

class PuppyManageSavePuppyEvent extends PuppyManageEvent{
  PuppyManageSavePuppyEvent();
}

class PuppyManageSetImageEvent extends PuppyManageEvent {
  PuppyManageSetImageEvent(this.source);
  final ImagePickerAction source;
}
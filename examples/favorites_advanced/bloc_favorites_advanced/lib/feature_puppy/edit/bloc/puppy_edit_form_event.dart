part of 'puppy_edit_form_bloc.dart';

@immutable
abstract class PuppyEditFormEvent extends FormBlocEvent{}

class PuppyEditFormSetImageEvent extends PuppyEditFormEvent {
  PuppyEditFormSetImageEvent({required this.source});

  final ImagePickerAction source;

  @override
  List<Object?> get props =>  [source];
}

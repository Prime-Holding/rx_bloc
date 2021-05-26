part of 'puppy_edit_form_bloc.dart';

@immutable
class PuppyEditFormState extends FormBlocState<String, String>{
   PuppyEditFormState({required this.path}) :
         super(currentStep: 1,isEditing: true) ;

  final String path;
  @override
  List<Object?> get props => [path];

}
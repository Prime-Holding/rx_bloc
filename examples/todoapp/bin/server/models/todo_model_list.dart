import 'package:json_annotation/json_annotation.dart';
import 'package:todoapp/base/models/todo_model.dart';

part 'todo_model_list.g.dart';

@JsonSerializable()
class TodoModelList {
  final List<TodoModel> todos;

  TodoModelList({required this.todos});

  factory TodoModelList.fromJson(Map<String, dynamic> json) =>
      _$TodoModelListFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelListToJson(this);
}

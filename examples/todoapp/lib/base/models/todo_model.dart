// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rx_bloc_list/models.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel with EquatableMixin implements Identifiable {
  TodoModel({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
    required this.createdAt,
  });

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    int? createdAt,
  }) =>
      TodoModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        completed: completed ?? this.completed,
        createdAt: createdAt ?? this.createdAt,
      );

  TodoModel copyFrom({
    required TodoModel todo,
  }) =>
      TodoModel(
        id: todo.id ?? id,
        title: todo.title,
        description: todo.description,
        completed: todo.completed,
        createdAt: todo.createdAt,
      );

  factory TodoModel.empty() => TodoModel(
        id: null,
        title: '',
        description: '',
        completed: false,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

  factory TodoModel.from({
    required String title,
    required String description,
    TodoModel? todo,
  }) =>
      TodoModel(
        id: todo?.id ,
        title: title,
        description: description,
        completed: todo?.completed ?? false,
        createdAt: todo?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
      );

  final String? id;

  final String title;

  final String description;

  final bool completed;

  final int createdAt;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id, title, description, completed, createdAt];

  @override
  bool isEqualToIdentifiable(Identifiable other) =>
      identical(this, other) ||
      (other is TodoModel && id != null && id == other.id);
}

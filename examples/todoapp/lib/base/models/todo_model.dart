// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
// ignore: implementation_imports
import 'package:rx_bloc_list/src/models/identifiable.dart';
part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel with EquatableMixin implements Identifiable {
  TodoModel({
    required this.id,
    required this.title,
    required this.createdAt,
    this.description = '',
    this.completed = false,
  });

  /// The unique identifier of the todo
  /// If the todo is not persisted yet, the id is null
  final String? id;

  /// The title of the todo
  ///
  /// The title is required and must not be null
  final String title;

  /// The description of the todo
  ///
  /// The description is optional and can be null
  /// The default value is an empty string
  final String description;

  /// The creation date of the todo
  ///
  /// The creation date is required and must not be null
  /// The default value is false
  final bool completed;

  /// The completion status of the todo
  ///
  /// The completion status is required and must not be null
  /// The default value is false
  final int createdAt;

  /// Creates a copy of the current todo with the provided changes
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

  /// Creates a copy of the current todo with the provided changes
  TodoModel copyFrom({required TodoModel todo}) => TodoModel(
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

  /// Creates a new todo with the provided title, description, and completion status
  factory TodoModel.from({
    required String title,
    required String description,
    TodoModel? todo,
  }) =>
      TodoModel(
        id: todo?.id,
        title: title,
        description: description,
        completed: todo?.completed ?? false,
        createdAt: todo?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
      );

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

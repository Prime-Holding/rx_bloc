// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:json_annotation/json_annotation.dart';
import 'package:realm/realm.dart';
// ignore: implementation_imports
import 'package:rx_bloc_list/src/models/identifiable.dart';

part 'todo_model.g.dart';
part 'todo_model.realm.dart';

enum TodoModelActions { add, update, delete, none }

@RealmModel()
@JsonSerializable()
class $TodoModel implements Identifiable {
  /// The unique identifier of the todo
  /// If the todo is not persisted yet, the id is null
  @PrimaryKey()
  @MapTo('_id')
  late String? id;

  /// The title of the todo
  ///
  /// The title is required and must not be null
  late String title;

  /// The description of the todo
  ///
  /// The description is optional and can be null
  /// The default value is an empty string
  late String description;

  /// The creation date of the todo
  ///
  /// The creation date is required and must not be null
  /// The default value is false
  late bool completed;

  /// The completion status of the todo
  ///
  /// The completion status is required and must not be null
  /// The default value is false
  late int createdAt;

  @JsonKey(includeFromJson: false, includeToJson: false)
  late bool? synced;

  late String? action;

  @JsonKey(includeFromJson: false, includeToJson: false)
  TodoModelActions get type =>
      TodoModelActions.values.byName(action ?? TodoModelActions.none.name);
  set type(final TodoModelActions value) => action = value.name;

  TodoModel toRealmObject() {
    return TodoModel(
      id,
      title,
      description,
      completed,
      createdAt,
      action: action ?? TodoModelActions.none.name,
    );
  }

  static TodoModel fromJson(Map<String, dynamic> json) =>
      _$$TodoModelFromJson(json).toRealmObject();

  Map<String, dynamic> toJson() => _$$TodoModelToJson(this);

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    int? createdAt,
    bool? synced,
    String? action,
  }) =>
      TodoModel(
        id ?? this.id,
        title ?? this.title,
        description ?? this.description,
        completed ?? this.completed,
        createdAt ?? this.createdAt,
        synced: synced ?? this.synced,
        action: action ?? this.action,
      );
  TodoModel copyFrom({required TodoModel todo}) => TodoModel(
        todo.id ?? id,
        todo.title,
        todo.description,
        todo.completed,
        todo.createdAt,
        synced: todo.synced,
        action: todo.action,
      );

  static TodoModel empty() => TodoModel(
        null,
        '',
        '',
        false,
        DateTime.now().millisecondsSinceEpoch,
        synced: true,
        action: TodoModelActions.add.name,
      );

  static TodoModel from(
    String title,
    String description,
    TodoModel? todo,
  ) =>
      TodoModel(
        todo?.id,
        title,
        description,
        todo?.completed ?? false,
        todo?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
        synced: todo?.synced ?? true,
        action: todo?.action ?? TodoModelActions.none.name,
      );

  @override
  bool isEqualToIdentifiable(Identifiable other) =>
      identical(this, other) ||
      (other is $TodoModel && id != null && id == other.id);
}

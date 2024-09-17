// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class TodoModel extends $TodoModel
    with RealmEntity, RealmObjectBase, RealmObject {
  TodoModel(
    String? id,
    String title,
    String description,
    bool completed,
    int createdAt, {
    bool? synced,
    String? action,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'completed', completed);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'synced', synced);
    RealmObjectBase.set(this, 'action', action);
  }

  TodoModel._();

  @override
  String? get id => RealmObjectBase.get<String>(this, '_id') as String?;
  @override
  set id(String? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  bool get completed => RealmObjectBase.get<bool>(this, 'completed') as bool;
  @override
  set completed(bool value) => RealmObjectBase.set(this, 'completed', value);

  @override
  int get createdAt => RealmObjectBase.get<int>(this, 'createdAt') as int;
  @override
  set createdAt(int value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  bool? get synced => RealmObjectBase.get<bool>(this, 'synced') as bool?;
  @override
  set synced(bool? value) => RealmObjectBase.set(this, 'synced', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  Stream<RealmObjectChanges<TodoModel>> get changes =>
      RealmObjectBase.getChanges<TodoModel>(this);

  @override
  Stream<RealmObjectChanges<TodoModel>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<TodoModel>(this, keyPaths);

  @override
  TodoModel freeze() => RealmObjectBase.freezeObject<TodoModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'title': title.toEJson(),
      'description': description.toEJson(),
      'completed': completed.toEJson(),
      'createdAt': createdAt.toEJson(),
      'synced': synced.toEJson(),
      'action': action.toEJson(),
    };
  }

  static EJsonValue _toEJson(TodoModel value) => value.toEJson();
  static TodoModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'title': EJsonValue title,
        'description': EJsonValue description,
        'completed': EJsonValue completed,
        'createdAt': EJsonValue createdAt,
      } =>
        TodoModel(
          fromEJson(ejson['_id']),
          fromEJson(title),
          fromEJson(description),
          fromEJson(completed),
          fromEJson(createdAt),
          synced: fromEJson(ejson['synced']),
          action: fromEJson(ejson['action']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(TodoModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, TodoModel, 'TodoModel', [
      SchemaProperty('id', RealmPropertyType.string,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('completed', RealmPropertyType.bool),
      SchemaProperty('createdAt', RealmPropertyType.int),
      SchemaProperty('synced', RealmPropertyType.bool, optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

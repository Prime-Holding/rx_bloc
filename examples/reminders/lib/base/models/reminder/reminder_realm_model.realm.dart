// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ReminderRealmModel extends _ReminderRealmModel
    with RealmEntity, RealmObjectBase, RealmObject {
  ReminderRealmModel(
    String id,
    String title,
    DateTime dueDate,
    bool complete, {
    String? authorId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'dueDate', dueDate);
    RealmObjectBase.set(this, 'complete', complete);
    RealmObjectBase.set(this, 'authorId', authorId);
  }

  ReminderRealmModel._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  DateTime get dueDate =>
      RealmObjectBase.get<DateTime>(this, 'dueDate') as DateTime;
  @override
  set dueDate(DateTime value) => RealmObjectBase.set(this, 'dueDate', value);

  @override
  bool get complete => RealmObjectBase.get<bool>(this, 'complete') as bool;
  @override
  set complete(bool value) => RealmObjectBase.set(this, 'complete', value);

  @override
  String? get authorId =>
      RealmObjectBase.get<String>(this, 'authorId') as String?;
  @override
  set authorId(String? value) => RealmObjectBase.set(this, 'authorId', value);

  @override
  Stream<RealmObjectChanges<ReminderRealmModel>> get changes =>
      RealmObjectBase.getChanges<ReminderRealmModel>(this);

  @override
  Stream<RealmObjectChanges<ReminderRealmModel>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ReminderRealmModel>(this, keyPaths);

  @override
  ReminderRealmModel freeze() =>
      RealmObjectBase.freezeObject<ReminderRealmModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'title': title.toEJson(),
      'dueDate': dueDate.toEJson(),
      'complete': complete.toEJson(),
      'authorId': authorId.toEJson(),
    };
  }

  static EJsonValue _toEJson(ReminderRealmModel value) => value.toEJson();
  static ReminderRealmModel _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'title': EJsonValue title,
        'dueDate': EJsonValue dueDate,
        'complete': EJsonValue complete,
        'authorId': EJsonValue authorId,
      } =>
        ReminderRealmModel(
          fromEJson(id),
          fromEJson(title),
          fromEJson(dueDate),
          fromEJson(complete),
          authorId: fromEJson(authorId),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ReminderRealmModel._);
    register(_toEJson, _fromEJson);
    return SchemaObject(
        ObjectType.realmObject, ReminderRealmModel, 'ReminderRealmModel', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('dueDate', RealmPropertyType.timestamp),
      SchemaProperty('complete', RealmPropertyType.bool),
      SchemaProperty('authorId', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

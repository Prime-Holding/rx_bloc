// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class PermissionModel extends $PermissionModel
    with RealmEntity, RealmObjectBase, RealmObject {
  PermissionModel(
    String? id, {
    Iterable<PermissionMap> permissions = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set<RealmList<PermissionMap>>(
        this, 'permissions', RealmList<PermissionMap>(permissions));
  }

  PermissionModel._();

  @override
  String? get id => RealmObjectBase.get<String>(this, '_id') as String?;
  @override
  set id(String? value) => throw RealmUnsupportedSetError();

  @override
  RealmList<PermissionMap> get permissions =>
      RealmObjectBase.get<PermissionMap>(this, 'permissions')
          as RealmList<PermissionMap>;
  @override
  set permissions(covariant RealmList<PermissionMap> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<PermissionModel>> get changes =>
      RealmObjectBase.getChanges<PermissionModel>(this);

  @override
  Stream<RealmObjectChanges<PermissionModel>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PermissionModel>(this, keyPaths);

  @override
  PermissionModel freeze() =>
      RealmObjectBase.freezeObject<PermissionModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'permissions': permissions.toEJson(),
    };
  }

  static EJsonValue _toEJson(PermissionModel value) => value.toEJson();
  static PermissionModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        '_id': EJsonValue id,
      } =>
        PermissionModel(
          fromEJson(ejson['_id']),
          permissions: fromEJson(ejson['permissions']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PermissionModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, PermissionModel, 'PermissionModel', [
      SchemaProperty('id', RealmPropertyType.string,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('permissions', RealmPropertyType.object,
          linkTarget: 'PermissionMap',
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

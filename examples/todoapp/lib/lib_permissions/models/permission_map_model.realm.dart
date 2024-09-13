// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_map_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class PermissionMap extends $PermissionMap
    with RealmEntity, RealmObjectBase, EmbeddedObject {
  PermissionMap(
    String permissionName,
    bool isEnabled,
  ) {
    RealmObjectBase.set(this, 'permissionName', permissionName);
    RealmObjectBase.set(this, 'isEnabled', isEnabled);
  }

  PermissionMap._();

  @override
  String get permissionName =>
      RealmObjectBase.get<String>(this, 'permissionName') as String;
  @override
  set permissionName(String value) =>
      RealmObjectBase.set(this, 'permissionName', value);

  @override
  bool get isEnabled => RealmObjectBase.get<bool>(this, 'isEnabled') as bool;
  @override
  set isEnabled(bool value) => RealmObjectBase.set(this, 'isEnabled', value);

  @override
  Stream<RealmObjectChanges<PermissionMap>> get changes =>
      RealmObjectBase.getChanges<PermissionMap>(this);

  @override
  Stream<RealmObjectChanges<PermissionMap>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PermissionMap>(this, keyPaths);

  @override
  PermissionMap freeze() => RealmObjectBase.freezeObject<PermissionMap>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'permissionName': permissionName.toEJson(),
      'isEnabled': isEnabled.toEJson(),
    };
  }

  static EJsonValue _toEJson(PermissionMap value) => value.toEJson();
  static PermissionMap _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'permissionName': EJsonValue permissionName,
        'isEnabled': EJsonValue isEnabled,
      } =>
        PermissionMap(
          fromEJson(permissionName),
          fromEJson(isEnabled),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PermissionMap._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.embeddedObject, PermissionMap, 'PermissionMap', [
      SchemaProperty('permissionName', RealmPropertyType.string),
      SchemaProperty('isEnabled', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

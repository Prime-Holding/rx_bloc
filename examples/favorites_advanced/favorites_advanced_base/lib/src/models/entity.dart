part '../extensions/entity_extensions.dart';

abstract class Entity {
  String get id;
  bool hasExtraDetails();
  bool hasFullExtraDetails();
  bool get isFavorite;

  T copyWithEntity<T extends Entity>(T entity);
}

part of '../models/entity.dart';

extension ListPuppyUtils<T extends Entity> on List<T> {
  /// Get a list of [Puppy.id]
  List<String> get ids => map((entity) => entity.id).toList();

  /// Get list of entities, which have no extra details
  List<T> whereNoExtraDetails() =>
      where((entity) => !entity.hasExtraDetails()).toList();

  /// Get list of entities, which have no full extra details
  List<T> whereNoFullExtraDetails() =>
      where((entity) => !entity.hasFullExtraDetails()).toList();

  /// Merge the current list with the given list of [T].
  ///
  /// 1. In case that any of the provided [T] it not part of the current
  /// list, the returned result will include the entities from the provided [T]
  /// 2. In case that any of the provided [T] it's not part of the
  /// current list it will be added at the end of the list.
  List<T> mergeWith(List<T> entities) {
    var copiedList = [...this];

    entities.forEach(
      (entity) => copiedList = copiedList._mergeWithEntity(entity),
    );

    return copiedList;
  }

  /// Get a list with added or removed entity based on the [T.isFavorite] flag
  List<T> manageFavoriteList(List<T> entities) {
    var copiedList = [...this];

    entities.forEach(
      (entity) => copiedList = copiedList._manageFavoriteEntity(entity),
    );

    return copiedList;
  }

  List<T> _mergeWithEntity(T entity) {
    final index = indexWhere((element) => element.id == entity.id);

    if (index >= 0 && index < length) {
      replaceRange(index, index + 1, [entity]);
      return this;
    }

    add(entity);

    return this;
  }

  //TODO cover the updating of the puppy with a unit test
  List<T> _manageFavoriteEntity(T entity) {
    //handle removing puppies which aren't favourite
    if (!entity.isFavorite) {
      removeWhere((element) => element.id == entity.id);
      return this;
    }

    final index = indexWhere((element) => element.id == entity.id);

    //handle adding new favourite puppy
    if (index == -1) {
      add(entity);
      return this;
    }

    //handle updating already existing favourite puppy
    this[index] = this[index].copyWithEntity(entity);

    return this;
  }
}

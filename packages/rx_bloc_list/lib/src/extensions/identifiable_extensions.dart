import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../models.dart';

/// The returned [ManageOperation] determines whether the [updatedIdentifiable]
/// will be merged, removed or ignored from the list.
typedef OperationCallback<E> = Future<ManageOperation> Function(
  E updatedIdentifiable,
);

extension ListIdentifiableUtils<T extends Identifiable> on List<T> {
  /// Get a list of unique [Identifiable.id]
  List<String> get ids => map((element) => element.id).toSet().toList();

  /// Whether the collection contains an element equal to [identifiable].
  bool containsIdentifiable(Identifiable identifiable) {
    try {
      firstWhere((element) => element.id == identifiable.id);

      return true;
    } on StateError catch (_) {
      return false;
    }
  }

  /// Return a new list with removed all occurrence of [identifiable] from this list.
  List<T> removedIdentifiable(Identifiable identifiable) {
    final list = [...this];
    list.removeWhere((element) => element.id == identifiable.id);

    return list;
  }

  /// Return a new list with the given [list] merged into the current list.
  ///
  /// 1. In case that any of the provided [T] is not part of the current
  /// list, the returned result will include the entities from the provided [T]
  /// 2. [addIfNotExist] In case that any of the provided [T] is not part of the
  /// current list it will be added at the end of the list.
  List<T> mergeWith(
    List<T> list, {
    bool addIfNotExist = true,
  }) {
    var copiedList = [...this];

    for (var item in list) {
      copiedList = copiedList._mergeWithEntity(
        item,
        addIfNotExist: addIfNotExist,
      );
    }

    return copiedList;
  }

  List<T> _mergeWithEntity(
    T entity, {
    required addIfNotExist,
  }) {
    final index = indexWhere((element) => element.id == entity.id);

    if (index >= 0 && index < length) {
      this[index] = entity;
      return this;
    }

    if (addIfNotExist) {
      add(entity);
    }

    return this;
  }
}

extension ModelManageEvents<E extends Identifiable> on Stream<E> {
  /// Merge or remove the value of the stream from the latest [list] value.
  /// The result, based on the [operationCallback], will be emitted as a new value.
  ///
  /// Examples:
  /// 1. The stream value will be removed from the [list] value
  /// ```
  /// objectStream.withLatestFromIdentifiableList(
  ///     listStream,
  ///     operationCallback: (updatedIdentifiable) async => ManageOperation.remove,
  /// )
  /// ```
  ///
  /// 2. The stream value will be merged into the [list] value
  /// ```
  /// objectStream.withLatestFromIdentifiableList(
  ///     listStream,
  ///     operationCallback: (updatedIdentifiable) async => ManageOperation.merge,
  /// )
  /// ```
  ///
  /// 3. The stream value won't be neither merged nor removed from the [list] value
  /// ```
  /// objectStream.withLatestFromIdentifiableList(
  ///     listStream,
  ///     operationCallback: (updatedIdentifiable) async => ManageOperation.ignore,
  /// )
  /// ```
  Stream<ManagedList<E>> withLatestFromIdentifiableList(
    Stream<List<E>> list, {
    required OperationCallback<E> operationCallback,
  }) =>
      _withLatestFromList(list).flatMap((tuple) async* {
        final identifiableInList = tuple.list
            .firstWhereOrNull((element) => element.id == tuple.item.id);
        switch (await operationCallback(tuple.item)) {
          case ManageOperation.merge:
            yield ManagedList(
              tuple.list._mergeWithList([tuple.item]),
              operation: ManageOperation.merge,
              identifiablePair: IdentifiablePair(
                  updatedIdentifiable: tuple.item,
                  oldIdentifiable: identifiableInList,
              ),
            );
            break;
          case ManageOperation.remove:
            yield ManagedList(
              tuple.list.removeFromList(tuple.item),
              operation: ManageOperation.remove,
              identifiablePair: IdentifiablePair(
                updatedIdentifiable: tuple.item,
                oldIdentifiable: identifiableInList,
              ),
            );
            break;
          case ManageOperation.ignore:
            yield ManagedList(
              tuple.list,
              operation: ManageOperation.ignore,
              identifiablePair: IdentifiablePair(
                updatedIdentifiable: tuple.item,
                oldIdentifiable: identifiableInList,
              ),
            );
            break;
        }
      });

  Stream<_Tuple<E>> _withLatestFromList(Stream<List<E>> list) =>
      withLatestFrom<List<E>, _Tuple<E>>(
        list,
        (identifiable, lastUpdatedList) =>
            _Tuple(identifiable, lastUpdatedList),
      );
}

extension ManagedListStreamX<E extends Identifiable> on Stream<ManagedList<E>> {
  Stream<List<E>> mapToList() => map((managedList) => managedList.list);
}

extension _ListX<E extends Identifiable> on List<E> {
  List<E> _mergeWithList(List<E> list) {
    if (this is PaginatedList<E>) {
      final paginatedList = (this as PaginatedList<E>);

      return paginatedList.copyWith(
        list: paginatedList.mergeWith(list),
      );
    }

    return mergeWith(list);
  }

  List<E> removeFromList(E identifiable) {
    final that = this;

    if (that is PaginatedList<E> && that.containsIdentifiable(identifiable)) {
      final totalCount = that.totalCount;

      return that.copyWith(
        list: that.removedIdentifiable(identifiable),
        totalCount: totalCount == null ? null : totalCount - 1,
      );
    }

    return removedIdentifiable(identifiable);
  }
}

class _Tuple<E> {
  _Tuple(this.item, this.list);

  final E item;
  final List<E> list;
}

extension ModelManageEventsPair<E extends Identifiable>
    on Stream<IdentifiablePair<E>> {
  /// Merge or remove the value of the stream from the latest [list] value.
  /// The result, based on the [operationCallback], will be emitted as a new value.
  ///
  /// Examples:
  /// 1. The stream value will be removed from the [list] value
  /// ```
  /// objectStream.withLatestFromIdentifiablePairList(
  ///     listStream,
  ///     operationCallback: (updatedIdentifiable) async => ManageOperation.remove,
  /// )
  /// ```
  ///
  /// 2. The stream value will be merged into the [list] value
  /// ```
  /// objectStream.withLatestFromIdentifiablePairList(
  ///     listStream,
  ///     operationCallback: (updatedIdentifiable) async => ManageOperation.merge,
  /// )
  /// ```
  ///
  /// 3. The stream value won't be neither merged nor removed from the [list] value
  /// ```
  /// objectStream.withLatestFromIdentifiablePairList(
  ///     listStream,
  ///     operationCallback: (updatedIdentifiable) async => ManageOperation.ignore,
  /// )
  /// ```
  Stream<ManagedList<E>> withLatestFromIdentifiablePairList(
    Stream<List<E>> list, {
    required OperationCallback<E> operationCallback,
  }) =>
      _withLatestFromListPair(list).flatMap((tuple) async* {
        switch (await operationCallback(tuple.pair.updatedIdentifiable)) {
          case ManageOperation.merge:
            yield ManagedList(
              tuple.list._mergeWithList([tuple.pair.updatedIdentifiable]),
              operation: ManageOperation.merge,
              identifiablePair: tuple.pair,
            );
            break;
          case ManageOperation.remove:
            yield ManagedList(
              tuple.list.removeFromList(tuple.pair.updatedIdentifiable),
              operation: ManageOperation.remove,
              identifiablePair: tuple.pair,
            );
            break;
          case ManageOperation.ignore:
            yield ManagedList(
              tuple.list,
              operation: ManageOperation.ignore,
              identifiablePair: tuple.pair,
            );
            break;
        }
      });

  Stream<_TuplePair<E>> _withLatestFromListPair(Stream<List<E>> list) =>
      withLatestFrom<List<E>, _TuplePair<E>>(
        list,
        (identifiablePair, lastUpdatedList) =>
            _TuplePair(identifiablePair, lastUpdatedList),
      );
}

class _TuplePair<E extends Identifiable> {
  _TuplePair(this.pair, this.list);

  final IdentifiablePair<E> pair;
  final List<E> list;
}

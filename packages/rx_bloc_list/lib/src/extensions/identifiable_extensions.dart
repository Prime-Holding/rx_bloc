import 'package:rxdart/rxdart.dart';

import '../../models.dart';

/// The returned [ManageOperation] determines whether the [updatedIdentifiable]
/// will be merged, removed or ignored from the list.
typedef OperationCallback<E extends Identifiable> = Future<ManageOperation>
    Function(E updatedIdentifiable, List<E> list);

extension ListIdentifiableUtils<T extends Identifiable> on List<T> {
  /// Whether the collection contains an element equal to [identifiable].
  bool containsIdentifiable(Identifiable identifiable) =>
      any((element) => element.isEqualToIdentifiable(identifiable));

  /// Return a new list with removed all occurrence of [identifiable] from this list.
  List<T> removedIdentifiable(Identifiable identifiable) =>
      where((element) => !element.isEqualToIdentifiable(identifiable)).toList();

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
    final index =
        indexWhere((element) => element.isEqualToIdentifiable(entity));

    if (index != -1) {
      this[index] = entity;
    } else if (addIfNotExist) {
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
  ///     operationCallback: (updatedIdentifiable, list) async => ManageOperation.remove,
  /// )
  /// ```
  ///
  /// 2. The stream value will be merged into the [list] value
  /// ```
  /// objectStream.withLatestFromIdentifiableList(
  ///     listStream,
  ///     operationCallback: (updatedIdentifiable, list) async => ManageOperation.merge,
  /// )
  /// ```
  ///
  /// 3. The stream value won't be neither merged nor removed from the [list] value
  /// ```
  /// objectStream.withLatestFromIdentifiableList(
  ///     listStream,
  ///     operationCallback: (updatedIdentifiable, list) async => ManageOperation.ignore,
  /// )
  /// ```
  Stream<ManagedList<E>> withLatestFromIdentifiableList(
    Stream<List<E>> list, {
    required OperationCallback<E> operationCallback,
  }) =>
      _withLatestFromList(list).flatMap((tuple) async* {
        switch (await operationCallback(tuple.item, tuple.list)) {
          case ManageOperation.merge:
            yield ManagedList(
              tuple.list._mergeWithList([tuple.item]),
              operation: ManageOperation.merge,
              identifiable: tuple.item,
            );
            break;
          case ManageOperation.remove:
            yield ManagedList(
              tuple.list._removeFromList(tuple.item),
              operation: ManageOperation.remove,
              identifiable: tuple.item,
            );
            break;
          case ManageOperation.ignore:
            yield ManagedList(
              tuple.list,
              operation: ManageOperation.ignore,
              identifiable: tuple.item,
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

  List<E> _removeFromList(E identifiable) {
    final that = this;

    if (that is PaginatedList<E>) {
      final totalCount = that.totalCount;
      if (that.containsIdentifiable(identifiable)) {
        return that.copyWith(
          list: that.removedIdentifiable(identifiable),
          totalCount: totalCount == null ? null : totalCount - 1,
        );
      }
      return that;
    }

    return removedIdentifiable(identifiable);
  }
}

class _Tuple<E> {
  _Tuple(this.item, this.list);

  final E item;
  final List<E> list;
}

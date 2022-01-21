import 'package:rxdart/rxdart.dart';

import '../../models.dart';

extension ListIdentifiableUtils<T extends Identifiable> on List<T> {
  /// Get a list of unique [Identifiable.id]
  List<String> get ids => map((element) => element.id).toSet().toList();

  bool containIdentifiable(Identifiable identifiable) {
    try {
      firstWhere((element) => element.id == identifiable.id);

      return true;
    } on StateError catch (_) {
      return false;
    }
  }

  List<T> removeIdentifiable(Identifiable identifiable) {
    final list = [...this];
    list.removeWhere((element) => element.id == identifiable.id);

    return list;
  }

  /// Merge the current list with the given list of [T].
  ///
  /// 1. In case that any of the provided [T] it not part of the current
  /// list, the returned result will include the entities from the provided [T]
  /// 2. [addIfNotExist] In case that any of the provided [T] it's not part of the
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
      replaceRange(index, index + 1, [entity]);
      return this;
    }

    if (addIfNotExist) {
      add(entity);
    }

    return this;
  }
}

extension ModelManageEvents<E extends Identifiable> on Stream<E> {
  Stream<List<E>> mapModelCreateEvents(
    Stream<List<E>> list, {
    required Future<bool> Function(E identifiable) addToListCondition,
  }) =>
      _withLatestFromList(list).flatMap((tuple) async* {
        if (await addToListCondition(tuple.item)) {
          yield tuple.list.complexMergeWith([tuple.item]);
          return;
        }

        yield tuple.list;
      });

  Stream<List<E>> mapModelUpdateEvents(
    Stream<List<E>> list, {
    required Future<bool> Function(E identifiable) removeFromListCondition,
  }) =>
      _withLatestFromList(list).flatMap(
        (tuple) async* {
          final removeFromList = await removeFromListCondition(tuple.item);

          if (removeFromList) {
            yield tuple.list.complexRemoveFromList(tuple.item);
            return;
          }

          yield tuple.list.complexMergeWith([tuple.item]);
        },
      );

  Stream<List<E>> mapModelDeleteEvents(
    Stream<List<E>> list,
  ) =>
      _withLatestFromList(list).flatMap((tuple) async* {
        yield tuple.list.complexRemoveFromList(tuple.item);
      });

  Stream<_Tuple<E>> _withLatestFromList(Stream<List<E>> list) =>
      withLatestFrom<List<E>, _Tuple<E>>(
        list,
        (identifiable, lastUpdatedList) =>
            _Tuple(identifiable, lastUpdatedList),
      );
}

extension _ListX<E extends Identifiable> on List<E> {
  List<E> complexMergeWith(List<E> list) {
    if (this is PaginatedList<E>) {
      final paginatedList = (this as PaginatedList<E>);

      return paginatedList.copyWith(
        list: paginatedList.mergeWith(list),
      );
    }

    return mergeWith(list);
  }

  List<E> complexRemoveFromList(E identifiable) {
    final that = this;

    if (that is PaginatedList<E> && that.containIdentifiable(identifiable)) {
      final totalCount = that.totalCount;

      return that.copyWith(
        list: that.removeIdentifiable(identifiable),
        totalCount: totalCount == null ? null : totalCount - 1,
      );
    }

    return removeIdentifiable(identifiable);
  }
}

class _Tuple<E> {
  _Tuple(this.item, this.list);

  final E item;
  final List<E> list;
}

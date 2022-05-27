import 'package:rxdart/rxdart.dart';

import '../../models.dart';

extension ModelManageEventsPair<E extends Identifiable>
    on Stream<IdentifiablePair<E>> {
  Stream<ManagedList<E>> withLatestFromIdentifiablePairList(
    Stream<List<E>> list,
    CounterOperation counterOperation, {
     required OperationCallback<E> operationCallback,
  }) =>
      _withLatestFromListPair(list).flatMap((tuple) async* {
        switch (await operationCallback(tuple.pair.updated)) {
          case ManageOperation.merge:
            yield ManagedList(
              tuple.list.mergeWithList([tuple.pair.updated]),
              counterOperation: counterOperation,
              operation: ManageOperation.merge,
              identifiable: tuple.pair.old,
              identifiableInList: tuple.pair.updated,
            );
            break;
          case ManageOperation.remove:
            yield ManagedList(
              tuple.list.removeFromList(tuple.pair.updated),
              counterOperation: counterOperation,
              operation: ManageOperation.remove,
              identifiable: tuple.pair.old,
              identifiableInList: tuple.pair.updated,
            );
            break;
          case ManageOperation.ignore:
            yield ManagedList(
              tuple.list,
              counterOperation: counterOperation,
              operation: ManageOperation.ignore,
              identifiable: tuple.pair.old,
              identifiableInList: tuple.pair.updated,
            );
            break;
        }
      });

  Stream<_TuplePair<E>> _withLatestFromListPair(
      Stream<List<E>> list) =>
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

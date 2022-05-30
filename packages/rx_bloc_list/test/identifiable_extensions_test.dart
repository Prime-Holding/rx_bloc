import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc_list/models.dart';

import 'stub.dart';

void main() {
  group('ListIdentifiableUtils', () {
    test('ListIdentifiableUtils.ids', () {
      expect(
        [
          IdentifiableModel('1'),
          IdentifiableModel('1'),
          IdentifiableModel('2'),
          IdentifiableModel('3'),
        ].ids,
        ['1', '2', '3'],
      );
    });

    test('ListIdentifiableUtils containIdentifiable', () {
      expect(
        [
          IdentifiableModel('1'),
          IdentifiableModel('1'),
          IdentifiableModel('2'),
          IdentifiableModel('3'),
        ].containsIdentifiable(IdentifiableModel('1')),
        true,
      );
    });

    test('ListIdentifiableUtils not containIdentifiable', () {
      expect(
        [
          IdentifiableModel('1'),
          IdentifiableModel('1'),
          IdentifiableModel('2'),
          IdentifiableModel('3'),
        ].containsIdentifiable(IdentifiableModel('4')),
        false,
      );
    });

    test('ListIdentifiableUtils removeIdentifiable', () {
      expect(
        [
          IdentifiableModel('1'),
          IdentifiableModel('2'),
          IdentifiableModel('3'),
        ].removedIdentifiable(IdentifiableModel('2')),
        [
          IdentifiableModel('1'),
          IdentifiableModel('3'),
        ],
      );
    });

    test('ListIdentifiableUtils mergeWith', () {
      expect(
        [
          IdentifiableModel('1', value: '1'),
          IdentifiableModel('2', value: '2'),
          IdentifiableModel('3', value: '3'),
        ].mergeWith([
          IdentifiableModel('2', value: 'updated 2'),
        ]).mergeWith([
          IdentifiableModel('4', value: '4'),
        ]).mergeWith([
          IdentifiableModel('5', value: '5'),
        ], addIfNotExist: false),
        [
          IdentifiableModel('1', value: '1'),
          IdentifiableModel('2', value: 'updated 2'),
          IdentifiableModel('3', value: '3'),
          IdentifiableModel('4', value: '4'),
        ],
      );
    });
  });

  group('ModelManageEvents', () {
    test('mapCreatedWithLatestFrom addToListCondition:true', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2')).withLatestFromIdentifiableList(
          Stream.value([IdentifiableModel('1')]),
          CounterOperation.create,
          operationCallback: (updatedIdentifiable) async {
            expect(updatedIdentifiable.id, '2');
            // expect(identifiableInList, isNull);
            return ManageOperation.merge;
          },
        ),
        emitsInOrder([
          ManagedList(
            [IdentifiableModel('1'), IdentifiableModel('2')],
            identifiable: IdentifiableModel('2'),
            operation: ManageOperation.merge,
            counterOperation: CounterOperation.create,
          )
        ]),
      );
    });

    test('mapCreatedWithLatestFrom addToListCondition:true (replace)',
        () async {
      await expectLater(
        Stream.value(
          IdentifiableModel('2', value: '2 updated'),
        ).withLatestFromIdentifiableList(
          Stream.value([
            IdentifiableModel('1'),
            IdentifiableModel('2'),
          ]),
          CounterOperation.update,
          operationCallback: (updatedIdentifiable) async {
            expect(updatedIdentifiable.id, '2');
            expect(updatedIdentifiable.value, '2 updated');
            // expect(identifiableInList!.value, '');
            return ManageOperation.merge;
          },
        ),
        emitsInOrder([
          ManagedList(
            [
              IdentifiableModel('1'),
              IdentifiableModel('2', value: '2 updated'),
            ],
            identifiable: IdentifiableModel('2'),
            operation: ManageOperation.merge,
            counterOperation: CounterOperation.update,
          ),
        ]),
      );
    });

    test('mapCreatedWithLatestFrom addToListCondition:false', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2')).withLatestFromIdentifiableList(
          Stream.value([IdentifiableModel('1')]),
          CounterOperation.create,
          operationCallback: (
            updatedIdentifiable,
          ) async {
            expect(updatedIdentifiable.id, '2');
            // expect(identifiableInList, isNull);
            return ManageOperation.ignore;
          },
        ),
        emitsInOrder([
          ManagedList(
            [IdentifiableModel('1')],
            identifiable: IdentifiableModel('2'),
            operation: ManageOperation.ignore,
            counterOperation: CounterOperation.create,
          ),
        ]),
      );
    });

    test('mapUpdatedWithLatestFrom removeFromListCondition:true', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2', value: 'b updated'))
            .withLatestFromIdentifiableList(
          Stream.value([
            IdentifiableModel('1', value: 'a'),
            IdentifiableModel('2', value: 'b'),
          ]),
          CounterOperation.delete,
          operationCallback: (updatedIdentifiable) async {
            if (updatedIdentifiable.id == '2') {
              expect(updatedIdentifiable.value, 'b updated');
              // expect(identifiableInList, isNotNull);
              // expect(identifiableInList!.value, 'b');
            }

            return ManageOperation.remove;
          },
        ),
        emitsInOrder([
          ManagedList(
            [IdentifiableModel('1', value: 'a')],
            identifiable: IdentifiableModel('2'),
            operation: ManageOperation.remove,
            counterOperation: CounterOperation.delete,
          )
        ]),
      );
    });

    test('mapUpdatedWithLatestFrom removeFromListCondition:false', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2', value: 'tt'))
            .withLatestFromIdentifiableList(
          Stream.value([
            IdentifiableModel('1'),
            IdentifiableModel('2'),
          ]),
          CounterOperation.update,
          operationCallback: (
            updatedIdentifiable,
          ) async {
            print('updatedIdentifiableVa: $updatedIdentifiable');
            return ManageOperation.ignore;
          },
        ),
        emitsInOrder([
          ManagedList(
            [
              IdentifiableModel('1'),
              IdentifiableModel('2'),
            ],
            identifiable: IdentifiableModel('2'),
            operation: ManageOperation.ignore,
            counterOperation: CounterOperation.update,
          )
        ]),
      );
    });

    test('mapDeletedWithLatestFrom', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2')).withLatestFromIdentifiableList(
          Stream.value(
            [
              IdentifiableModel('1'),
              IdentifiableModel('2'),
            ],
          ),
          CounterOperation.delete,
          operationCallback: (updatedIdentifiable) async =>
              ManageOperation.remove,
        ),
        emitsInOrder([
          ManagedList(
            [
              IdentifiableModel('1'),
            ],
            identifiable: IdentifiableModel('2'),
            operation: ManageOperation.remove,
            counterOperation: CounterOperation.update,
          ),
        ]),
      );
    });
  });

  group('ModelManageEvents PaginatedList', () {
    test('PaginatedList mapCreatedWithLatestFrom addToListCondition:true',
        () async {
      await expectLater(
        Stream.value(IdentifiableModel('2')).withLatestFromIdentifiableList(
          Stream.value(
            PaginatedList(
              list: [IdentifiableModel('1')],
              pageSize: 1,
              totalCount: 10,
            ),
          ),
          CounterOperation.create,
          operationCallback: (updatedIdentifiable) async =>
              ManageOperation.merge,
        ),
        emitsInOrder([
          ManagedList(
            PaginatedList(
              list: [IdentifiableModel('1'), IdentifiableModel('2')],
              pageSize: 1,
              totalCount: 11,
            ),
            identifiable: IdentifiableModel('2'),
            operation: ManageOperation.merge,
            counterOperation: CounterOperation.create,
          )
        ]),
      );
    });

    test('PaginatedList mapDeletedWithLatestFrom', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2')).withLatestFromIdentifiableList(
          Stream.value(
            PaginatedList(
              list: [
                IdentifiableModel('1'),
                IdentifiableModel('2'),
              ],
              pageSize: 2,
              totalCount: 10,
            ),
          ),
          CounterOperation.delete,
          operationCallback: (updatedIdentifiable) async =>
              ManageOperation.remove,
        ),
        emitsInOrder(
          [
            ManagedList(
              PaginatedList(
                list: [IdentifiableModel('1')],
                pageSize: 2,
                totalCount: 9,
              ),
              identifiable: IdentifiableModel('2'),
              operation: ManageOperation.remove,
              counterOperation: CounterOperation.delete,
            )
          ],
        ),
      );
    });
  });
}

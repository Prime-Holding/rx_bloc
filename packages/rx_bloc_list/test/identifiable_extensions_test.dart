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
          operationCallback: (updatedIdentifiable, identifiableInList) async {
            expect(updatedIdentifiable.id, '2');
            expect(identifiableInList, isNull);
            return ManageOperation.merge;
          },
        ),
        emitsInOrder([
          [IdentifiableModel('1'), IdentifiableModel('2')],
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
          operationCallback: (updatedIdentifiable, identifiableInList) async {
            expect(updatedIdentifiable.id, '2');
            expect(updatedIdentifiable.value, '2 updated');
            expect(identifiableInList!.value, '');
            return ManageOperation.merge;
          },
        ),
        emitsInOrder([
          [
            IdentifiableModel('1'),
            IdentifiableModel('2', value: '2 updated'),
          ],
        ]),
      );
    });

    test('mapCreatedWithLatestFrom addToListCondition:false', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2')).withLatestFromIdentifiableList(
          Stream.value([IdentifiableModel('1')]),
          operationCallback: (updatedIdentifiable, identifiableInList) async {
            expect(updatedIdentifiable.id, '2');
            expect(identifiableInList, isNull);
            return ManageOperation.ignore;
          },
        ),
        emitsInOrder([
          [IdentifiableModel('1')],
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
          operationCallback: (updatedIdentifiable, identifiableInList) async {
            if (updatedIdentifiable.id == '2') {
              expect(updatedIdentifiable.value, 'b updated');
              expect(identifiableInList, isNotNull);
              expect(identifiableInList!.value, 'b');
            }

            return ManageOperation.remove;
          },
        ),
        emitsInOrder([
          [IdentifiableModel('1', value: 'a')],
        ]),
      );
    });

    test('mapUpdatedWithLatestFrom removeFromListCondition:false', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2')).withLatestFromIdentifiableList(
          Stream.value([
            IdentifiableModel('1'),
            IdentifiableModel('2'),
          ]),
          operationCallback: (updatedIdentifiable, identifiableInList) async =>
              ManageOperation.ignore,
        ),
        emitsInOrder([
          [
            IdentifiableModel('1'),
            IdentifiableModel('2'),
          ],
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
          operationCallback: (updatedIdentifiable, identifiableInList) async =>
              ManageOperation.remove,
        ),
        emitsInOrder([
          [
            IdentifiableModel('1'),
          ],
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
          operationCallback: (updatedIdentifiable, identifiableInList) async =>
              ManageOperation.merge,
        ),
        emitsInOrder([
          PaginatedList(
            list: [IdentifiableModel('1'), IdentifiableModel('2')],
            pageSize: 1,
            totalCount: 11,
          ),
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
          operationCallback: (updatedIdentifiable, identifiableInList) async =>
              ManageOperation.remove,
        ),
        emitsInOrder(
          [
            PaginatedList(
              list: [IdentifiableModel('1')],
              pageSize: 2,
              totalCount: 9,
            )
          ],
        ),
      );
    });
  });
}

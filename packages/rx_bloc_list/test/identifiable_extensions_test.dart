import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc_list/models.dart';

import 'stub.dart';

void main() {
  group('ListIdentifiableUtils', () {
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
    test('withLatestFromIdentifiableList addToListCondition:true', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2')).withLatestFromIdentifiableList(
          Stream.value([IdentifiableModel('1')]),
          operationCallback: (IdentifiableModel updatedIdentifiable,
              List<IdentifiableModel> list) async {
            expect(updatedIdentifiable.id, '2');
            expect(updatedIdentifiable.value, '');
            return ManageOperation.merge;
          },
        ),
        emitsInOrder([
          ManagedList<IdentifiableModel>(
            [IdentifiableModel('1'), IdentifiableModel('2')],
            identifiable: IdentifiableModel('2'),
            operation: ManageOperation.merge,
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
          operationCallback: (IdentifiableModel updatedIdentifiable,
              List<IdentifiableModel> list) async {
            expect(updatedIdentifiable.id, '2');
            expect(updatedIdentifiable.value, '2 updated');
            return ManageOperation.merge;
          },
        ),
        emitsInOrder([
          ManagedList(
            [
              IdentifiableModel('1'),
              IdentifiableModel('2', value: '2 updated'),
            ],
            identifiable: IdentifiableModel('2', value: '2 updated'),
            operation: ManageOperation.merge,
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
          operationCallback: (IdentifiableModel updatedIdentifiable,
              List<IdentifiableModel> list) async {
            expect(updatedIdentifiable.id, '2');
            expect(updatedIdentifiable.value, 'b updated');
            return ManageOperation.remove;
          },
        ),
        emitsInOrder([
          ManagedList<IdentifiableModel>(
            [IdentifiableModel('1', value: 'a')],
            identifiable: IdentifiableModel('2', value: 'b updated'),
            operation: ManageOperation.remove,
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
          operationCallback: (IdentifiableModel updatedIdentifiable,
                  List<IdentifiableModel> list) async =>
              ManageOperation.ignore,
        ),
        emitsInOrder([
          ManagedList<IdentifiableModel>(
            [
              IdentifiableModel('1'),
              IdentifiableModel('2'),
            ],
            identifiable: IdentifiableModel('2', value: 'tt'),
            operation: ManageOperation.ignore,
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
          operationCallback: (IdentifiableModel identifiablePair,
                  List<IdentifiableModel> list) async =>
              ManageOperation.remove,
        ),
        emitsInOrder([
          ManagedList<IdentifiableModel>(
            [
              IdentifiableModel('1'),
            ],
            identifiable: IdentifiableModel('2'),
            operation: ManageOperation.remove,
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
          operationCallback: (IdentifiableModel identifiablePair,
                  List<IdentifiableModel> list) async =>
              ManageOperation.merge,
        ),
        emitsInOrder([
          ManagedList<IdentifiableModel>(
            PaginatedList(
              list: [IdentifiableModel('1'), IdentifiableModel('2')],
              pageSize: 1,
              totalCount: 11,
            ),
            identifiable: IdentifiableModel('2'),
            operation: ManageOperation.merge,
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
          operationCallback: (IdentifiableModel identifiablePair,
                  List<IdentifiableModel> list) async =>
              ManageOperation.remove,
        ),
        emitsInOrder(
          [
            ManagedList<IdentifiableModel>(
              PaginatedList(
                list: [IdentifiableModel('1')],
                pageSize: 2,
                totalCount: 9,
              ),
              identifiable: IdentifiableModel('2'),
              operation: ManageOperation.remove,
            )
          ],
        ),
      );
    });
  });

  group('ManagedList', () {
    test('ManagedList mapToList', () async {
      await expectLater(
        Stream.value(ManagedList<IdentifiableModel>(
          [
            IdentifiableModel('1'),
            IdentifiableModel('2'),
          ],
          identifiable: IdentifiableModel('2', value: 'updated 2'),
          operation: ManageOperation.ignore,
        )).mapToList(),
        emitsInOrder([
          [
            IdentifiableModel('1'),
            IdentifiableModel('2'),
          ]
        ]),
      );
    });
  });
}

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
    test('withLatestFromIdentifiableList addToListCondition:true', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2')).withLatestFromIdentifiableList(
          Stream.value([IdentifiableModel('1')]),
          operationCallback: (identifiablePair) async {
            expect(identifiablePair.updatedIdentifiable.id, '2');
            return ManageOperation.merge;
          },
        ),
        emitsInOrder([
          ManagedList<IdentifiableModel>(
            [IdentifiableModel('1'), IdentifiableModel('2')],
            identifiablePair: IdentifiablePair(
              oldIdentifiable: null,
              updatedIdentifiable: IdentifiableModel('2'),
            ),
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
          operationCallback: (identifiablePair) async {
            expect(identifiablePair.updatedIdentifiable.id, '2');
            expect(identifiablePair.updatedIdentifiable.value, '2 updated');
            return ManageOperation.merge;
          },
        ),
        emitsInOrder([
          ManagedList(
            [
              IdentifiableModel('1'),
              IdentifiableModel('2', value: '2 updated'),
            ],
            identifiablePair: IdentifiablePair(
              oldIdentifiable: IdentifiableModel('2'),
              updatedIdentifiable: IdentifiableModel('2'),
            ),
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
          operationCallback: (identifiablePair) async {
            if (identifiablePair.updatedIdentifiable.id == '2') {
              expect(identifiablePair.updatedIdentifiable.value, 'b updated');
            }

            return ManageOperation.remove;
          },
        ),
        emitsInOrder([
          ManagedList<IdentifiableModel>(
            [IdentifiableModel('1', value: 'a')],
            identifiablePair: IdentifiablePair<IdentifiableModel>(
              updatedIdentifiable: IdentifiableModel('2', value: 'b'),
              oldIdentifiable: IdentifiableModel('2'),
            ),
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
          operationCallback: (updatedIdentifiable) async =>
              ManageOperation.ignore,
        ),
        emitsInOrder([
          ManagedList<IdentifiableModel>(
            [
              IdentifiableModel('1'),
              IdentifiableModel('2'),
            ],
            identifiablePair: IdentifiablePair(
              updatedIdentifiable: IdentifiableModel('2', value: 'tt'),
              oldIdentifiable: IdentifiableModel('2'),
            ),
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
          operationCallback: (updatedIdentifiable) async =>
              ManageOperation.remove,
        ),
        emitsInOrder([
          ManagedList<IdentifiableModel>(
            [
              IdentifiableModel('1'),
            ],
            identifiablePair: IdentifiablePair(
              updatedIdentifiable: IdentifiableModel('2'),
              oldIdentifiable: IdentifiableModel('2'),
            ),
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
          operationCallback: (updatedIdentifiable) async =>
              ManageOperation.merge,
        ),
        emitsInOrder([
          ManagedList<IdentifiableModel>(
            PaginatedList(
              list: [IdentifiableModel('1'), IdentifiableModel('2')],
              pageSize: 1,
              totalCount: 11,
            ),
            identifiablePair: IdentifiablePair(
              updatedIdentifiable: IdentifiableModel('2'),
            ),
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
          operationCallback: (updatedIdentifiable) async =>
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
              identifiablePair: IdentifiablePair(
                updatedIdentifiable: IdentifiableModel('2'),
                oldIdentifiable: IdentifiableModel('2'),
              ),
              operation: ManageOperation.remove,
            )
          ],
        ),
      );
    });
  });

  group('ModelManageEvents withLatestFromIdentifiablePairList', () {
    test('ModelManageEvents mapCreatedWithLatestFrom addToListCondition:true',
        () async {
      await expectLater(
        Stream.value(IdentifiablePair<IdentifiableModel>(
          oldIdentifiable: IdentifiableModel('2'),
          updatedIdentifiable: IdentifiableModel('2'),
        )).withLatestFromIdentifiablePairList(
          Stream.value(
            [
              IdentifiableModel('1'),
            ],
          ),
          operationCallback: (updatedIdentifiable) async =>
              ManageOperation.merge,
        ),
        emitsInOrder(
          [
            ManagedList<IdentifiableModel>(
              [
                IdentifiableModel('1'),
                IdentifiableModel('2'),
              ],
              identifiablePair: IdentifiablePair<IdentifiableModel>(
                oldIdentifiable: IdentifiableModel('2'),
                updatedIdentifiable: IdentifiableModel('2'),
              ),
              operation: ManageOperation.merge,
            )
          ],
        ),
      );
    });

    test('ModelManageEvents mapDeletedWithLatestFrom', () async {
      await expectLater(
        Stream.value(IdentifiablePair<IdentifiableModel>(
          oldIdentifiable: IdentifiableModel('2'),
          updatedIdentifiable: IdentifiableModel('2'),
        )).withLatestFromIdentifiablePairList(
          Stream.value(
            [
              IdentifiableModel('1'),
              IdentifiableModel('2'),
            ],
          ),
          operationCallback: (updatedIdentifiable) async =>
              ManageOperation.remove,
        ),
        emitsInOrder(
          [
            ManagedList<IdentifiableModel>(
              [
                IdentifiableModel('1'),
              ],
              identifiablePair: IdentifiablePair<IdentifiableModel>(
                oldIdentifiable: IdentifiableModel('2'),
                updatedIdentifiable: IdentifiableModel('2'),
              ),
              operation: ManageOperation.remove,
            )
          ],
        ),
      );
    });

    test('ModelManageEvents removeFromListCondition:false', () async {
      await expectLater(
        Stream.value(IdentifiablePair<IdentifiableModel>(
          oldIdentifiable: IdentifiableModel('2'),
          updatedIdentifiable: IdentifiableModel('2'),
        )).withLatestFromIdentifiablePairList(
          Stream.value(
            [
              IdentifiableModel('1'),
              IdentifiableModel('2'),
            ],
          ),
          operationCallback: (updatedIdentifiable) async =>
              ManageOperation.ignore,
        ),
        emitsInOrder(
          [
            ManagedList<IdentifiableModel>(
              [
                IdentifiableModel('1'),
                IdentifiableModel('2'),
              ],
              identifiablePair: IdentifiablePair<IdentifiableModel>(
                oldIdentifiable: IdentifiableModel('2'),
                updatedIdentifiable: IdentifiableModel('2'),
              ),
              operation: ManageOperation.ignore,
            )
          ],
        ),
      );
    });
  });
}

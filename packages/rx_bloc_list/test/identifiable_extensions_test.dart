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
        ].removeIdentifiable(IdentifiableModel('2')),
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
        Stream.value(IdentifiableModel('2')).mapCreatedWithLatestFrom(
          Stream.value([IdentifiableModel('1')]),
          addToListCondition: (identifiable) async => true,
        ),
        emitsInOrder([
          [IdentifiableModel('1'), IdentifiableModel('2')],
        ]),
      );
    });

    test('mapCreatedWithLatestFrom addToListCondition:false', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2')).mapCreatedWithLatestFrom(
          Stream.value([IdentifiableModel('1')]),
          addToListCondition: (identifiable) async => false,
        ),
        emitsInOrder([
          [IdentifiableModel('1')],
        ]),
      );
    });

    test('mapUpdatedWithLatestFrom removeFromListCondition:true', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2')).mapUpdatedWithLatestFrom(
          Stream.value([
            IdentifiableModel('1'),
            IdentifiableModel('2'),
          ]),
          removeFromListCondition: (identifiable) async => true,
        ),
        emitsInOrder([
          [IdentifiableModel('1')],
        ]),
      );
    });

    test('mapUpdatedWithLatestFrom removeFromListCondition:false', () async {
      await expectLater(
        Stream.value(IdentifiableModel('2')).mapUpdatedWithLatestFrom(
          Stream.value([
            IdentifiableModel('1'),
            IdentifiableModel('2'),
          ]),
          removeFromListCondition: (identifiable) async => false,
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
        Stream.value(IdentifiableModel('2')).mapDeletedWithLatestFrom(
          Stream.value([
            IdentifiableModel('1'),
            IdentifiableModel('2'),
          ]),
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
        Stream.value(IdentifiableModel('2')).mapCreatedWithLatestFrom(
          Stream.value(
            PaginatedList(
              list: [IdentifiableModel('1')],
              pageSize: 1,
              totalCount: 10,
            ),
          ),
          addToListCondition: (identifiable) async => true,
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
        Stream.value(IdentifiableModel('2')).mapDeletedWithLatestFrom(
          Stream.value(PaginatedList(
            list: [
              IdentifiableModel('1'),
              IdentifiableModel('2'),
            ],
            pageSize: 2,
            totalCount: 10,
          )),
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

import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc_list/models.dart';

void main() {
  group('PaginatedList tests', () {
    const listSize = 100;
    const pageSize = 10;
    final emptyListData = [];
    final notEmptyListData = [0, 1, 2, 3];

    test('PaginatedList.toString', () {
      final list = PaginatedList(list: notEmptyListData, pageSize: pageSize);

      expect(
        list.toString(),
        '{pageSize: 10, error: null, totalCount: null,'
        ' isLoading: false, list: [0, 1, 2, 3]}',
      );
    });

    test('PaginatedList.copyWith', () {
      final list = PaginatedList(list: emptyListData, pageSize: pageSize);

      expect(list.copyWith(list: notEmptyListData), notEmptyListData);
    });

    test('PaginatedList.getItem', () {
      final list = PaginatedList(list: notEmptyListData, pageSize: pageSize);

      expect(list.getItem(1), 1);
      expect(list.getItem(20), isNull);
    });

    test('PaginatedList assign to index', () {
      final list = PaginatedList(list: notEmptyListData, pageSize: pageSize);
      list[1] = 2;
      expect(list[1], 2);
    });

    test('List length when list is empty', () {
      final list = PaginatedList(list: emptyListData, pageSize: pageSize);
      expect(list.length, equals(0));
    });

    test('List length when list has data', () {
      final list = PaginatedList(
        list: List.generate(listSize, (index) => index + 1),
        pageSize: pageSize,
      );
      expect(list.length, equals(listSize));
    });

    test('List length after data reset', () {
      final list = PaginatedList(
        list: List.generate(listSize, (index) => index + 1),
        pageSize: pageSize,
      );
      expect(list.length, equals(listSize));
      list.reset();
      expect(list.length, equals(0));
    });

    test('Page number when list has no data', () {
      final list = PaginatedList(list: emptyListData, pageSize: pageSize);
      expect(list.pageNumber, equals(0));
    });

    test('Page number when list has data', () {
      final list = PaginatedList(
        list: List.generate(listSize, (index) => index),
        pageSize: pageSize,
      );
      expect(list.pageNumber, equals(listSize / pageSize));
    });

    test('PaginatedList has no next page to load', () {
      final list = PaginatedList(
        list: List.generate(listSize, (index) => index),
        pageSize: pageSize,
        totalCount: listSize,
      );
      expect(list.hasNextPage, equals(false));
    });

    test('PaginatedList has next page to load', () {
      final list = PaginatedList(
        list: List.generate(listSize, (index) => index),
        pageSize: pageSize,
        totalCount: listSize + 1,
      );
      expect(list.hasNextPage, equals(true));
    });

    test('Next page to load when no data (pagination starts at 0)', () {
      final list = PaginatedList(
        list: emptyListData,
        pageSize: pageSize,
        totalCount: 0,
      );
      expect(list.pageToLoad, equals(0));
    });

    test('Next page to load when there is data (pagination starts at 0)', () {
      final list = PaginatedList(
        list: List.generate(pageSize * 2, (index) => index),
        pageSize: pageSize,
        totalCount: pageSize * 2,
      );
      expect(list.pageToLoad, equals(2));
    });

    test('Initial loading when there is no data', () {
      final list = PaginatedList(
        list: emptyListData,
        pageSize: pageSize,
        isLoading: true,
      );
      expect(list.isInitialLoading, equals(true));
    });

    test('Initial loading when there is data', () {
      final list = PaginatedList(
        list: List.generate(listSize, (index) => index),
        pageSize: pageSize,
        isLoading: true,
      );
      expect(list.isInitialLoading, equals(false));
    });

    test('Next page loading when there is no data', () {
      final list = PaginatedList(
        list: emptyListData,
        pageSize: pageSize,
        isLoading: true,
      );
      expect(list.isNextPageLoading, equals(false));
    });

    test('Next page loading when there is data', () {
      final list = PaginatedList(
        list: List.generate(listSize, (index) => index),
        pageSize: pageSize,
        isLoading: true,
      );
      expect(list.isNextPageLoading, equals(true));
    });

    test('Item count when data is not loading', () {
      final list = PaginatedList(
        list: List.generate(listSize, (index) => index),
        pageSize: pageSize,
        isLoading: false,
      );
      expect(list.itemCount, equals(listSize));
    });

    test('Item count when reach the last page', () {
      final list = PaginatedList(
        list: List.generate(listSize, (index) => index),
        pageSize: pageSize,
        isLoading: true,
        totalCount: listSize,
      );
      expect(list.itemCount, equals(listSize));
    });

    test('Item count when data is loading', () {
      final list = PaginatedList(
        list: List.generate(listSize, (index) => index),
        pageSize: pageSize,
        isLoading: true,
      );
      expect(list.itemCount, equals(listSize + 1));
    });
  });
}

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

import 'stub.dart';

void main() {
  group('Stream<PaginatedList<T>>', () {
    test('waitToLoad completes', () {
      final pageSubject = BehaviorSubject.seeded(PaginatedList(
        list: Stub.pageEmpty,
        pageSize: 1,
      ));

      Rx.merge<Result<PaginatedList<int>>>([
        Stub.steamPage(Stub.pageOne, delay: 10),
      ]).mergeWithPaginatedList(pageSubject).bind(pageSubject);

      expect(
        pageSubject.waitToLoad(),
        completes,
      );
    });

    test('waitToLoad does not complete', () {
      //ignore: close_sinks
      final pageSubject = BehaviorSubject.seeded(PaginatedList(
        list: Stub.pageEmpty,
        pageSize: 1,
      ));

      expect(
        pageSubject.waitToLoad(),
        doesNotComplete,
      );
    });
  });

  group('AsyncSnapshot<PaginatedList<T>>', () {
    test('isInitialLoading has data', () async {
      final snapshot = AsyncSnapshot.withData(
          ConnectionState.done,
          PaginatedList(
            list: Stub.pageEmpty,
            pageSize: 1,
            isInitialized: false,
            isLoading: true,
          ));

      expect(snapshot.isInitialLoading, true);
    });

    test('isInitialLoading has no data', () async {
      const snapshot = AsyncSnapshot<PaginatedList<int>>.waiting();
      expect(snapshot.isInitialLoading, true);
    });

    test('isInitialLoading nothing', () async {
      const snapshot = AsyncSnapshot<PaginatedList<int>>.nothing();
      expect(snapshot.isInitialLoading, true);
    });

    test('isNextPageLoading', () async {
      const snapshotNothing = AsyncSnapshot<PaginatedList<int>>.nothing();
      expect(snapshotNothing.isNextPageLoading, true);

      final snapshotData = AsyncSnapshot<PaginatedList<int>>.withData(
        ConnectionState.done,
        PaginatedList(list: [1], isLoading: true, pageSize: 1),
      );

      expect(snapshotData.isNextPageLoading, true);
    });

    test('isLoading', () async {
      const snapshotNothing = AsyncSnapshot<PaginatedList<int>>.nothing();
      expect(snapshotNothing.isLoading, true);

      final snapshotData = AsyncSnapshot<PaginatedList<int>>.withData(
        ConnectionState.done,
        PaginatedList(list: [1], isLoading: true, pageSize: 1),
      );

      expect(snapshotData.isLoading, true);
    });

    test('hasPageError', () async {
      const snapshotNothing = AsyncSnapshot<PaginatedList<int>>.nothing();
      expect(snapshotNothing.hasPageError, false);

      final snapshotData = AsyncSnapshot<PaginatedList<int>>.withData(
        ConnectionState.done,
        PaginatedList(list: [], pageSize: 1, error: Exception('a')),
      );

      expect(snapshotData.hasPageError, true);
    });

    test('getItem', () async {
      final snapshotData = AsyncSnapshot<PaginatedList<int>>.withData(
        ConnectionState.done,
        PaginatedList(list: [0, 1, 2], pageSize: 1),
      );

      expect(snapshotData.getItem(1), 1);
    });

    test('itemCount', () async {
      final snapshotData = AsyncSnapshot<PaginatedList<int>>.withData(
        ConnectionState.done,
        PaginatedList(list: [0, 1, 2], pageSize: 1),
      );

      expect(snapshotData.itemCount, 3);
    });

    test('pageNumber', () async {
      final snapshotDataPageOne = AsyncSnapshot<PaginatedList<int>>.withData(
        ConnectionState.done,
        PaginatedList(list: [0, 1, 2], pageSize: 3, totalCount: 6),
      );

      expect(snapshotDataPageOne.pageNumber, 1);

      final snapshotDataPageTwo = AsyncSnapshot<PaginatedList<int>>.withData(
        ConnectionState.done,
        PaginatedList(list: [0, 1, 2, 3, 4, 5, 6], pageSize: 3),
      );

      expect(snapshotDataPageTwo.pageNumber, 3);
    });
  });

  group('Stream<Result<PaginatedList<T>>>.mergeWithPaginatedList', () {
    test('error, success', () async {
      final pageSubject = BehaviorSubject.seeded(PaginatedList(
        list: Stub.pageOne,
        pageSize: 1,
      ));

      Rx.merge<Result<PaginatedList<int>>>([
        Stub.streamPageError(delay: 5),
        Stub.steamPage(Stub.pageOne, delay: 10),
      ]).mergeWithPaginatedList(pageSubject).bind(pageSubject);

      await expectLater(
        pageSubject,
        emitsInOrder(
          <PaginatedList<int>>[
            PaginatedList(list: Stub.pageOne, pageSize: 1, isLoading: false),
            PaginatedList(list: Stub.pageOne, pageSize: 1, isLoading: true),
            PaginatedList(list: Stub.pageEmpty, pageSize: 1, isLoading: false),
            PaginatedList(list: Stub.pageEmpty, pageSize: 1, isLoading: true),
            PaginatedList(list: Stub.pageOne, pageSize: 1, isLoading: false),
          ],
        ),
      );
    });

    test('reset', () async {
      final pageSubject = BehaviorSubject.seeded(PaginatedList(
        list: Stub.pageEmpty,
        pageSize: 1,
      ));

      Rx.merge([
        Stub.steamPage(
          Stub.pageOne,
          delay: 10,
        ),
        Stub.steamPage(
          Stub.pageTwo,
          delay: 20,
        ),
        Stub.steamPage(
          Stub.pageOne,
          delay: 30,
          onEvent: () => pageSubject.value.reset(),
        ),
      ]).mergeWithPaginatedList(pageSubject).bind(pageSubject);

      await expectLater(
        pageSubject,
        emitsInOrder(
          <PaginatedList<int>>[
            PaginatedList(list: Stub.pageEmpty, pageSize: 1, isLoading: false),
            PaginatedList(list: Stub.pageEmpty, pageSize: 1, isLoading: true),
            PaginatedList(list: Stub.pageOne, pageSize: 1, isLoading: false),
            PaginatedList(list: Stub.pageOne, pageSize: 1, isLoading: true),
            PaginatedList(list: Stub.pageOneTwo, pageSize: 1, isLoading: false),
          ],
        ),
      );
    });

    test('hard reset', () {
      final pageSubject = BehaviorSubject.seeded(PaginatedList(
        list: Stub.pageOne,
        pageSize: 1,
      ));

      Rx.merge([
        Stub.steamPage(
          Stub.pageTwo,
          delay: 10,
        ),
        Stub.steamPage(
          Stub.pageOne,
          delay: 20,
          onEvent: () => pageSubject.value.reset(),
        ),
      ]).mergeWithPaginatedList(pageSubject).bind(pageSubject);

      expectLater(
        pageSubject,
        emitsInOrder(
          <PaginatedList<int>>[
            PaginatedList(list: Stub.pageOne, pageSize: 1, isLoading: false),
            PaginatedList(list: Stub.pageOne, pageSize: 1, isLoading: true),
            PaginatedList(list: Stub.pageOneTwo, pageSize: 1, isLoading: false),
            PaginatedList(list: Stub.pageEmpty, pageSize: 1, isLoading: true),
            PaginatedList(list: Stub.pageOne, pageSize: 1, isLoading: false),
          ],
        ),
      );
    });

    test('load second and third page', () {
      final pageSubject = BehaviorSubject.seeded(PaginatedList(
        list: Stub.pageOne,
        pageSize: 1,
      ));

      Rx.merge([
        Stub.steamPage(Stub.pageTwo, delay: 5),
        Stub.steamPage(Stub.pageThree, delay: 10),
      ]).mergeWithPaginatedList(pageSubject).bind(pageSubject);

      expectLater(
        pageSubject,
        emitsInOrder(
          <PaginatedList<int>>[
            PaginatedList(list: Stub.pageOne, pageSize: 1, isLoading: false),
            PaginatedList(list: Stub.pageOne, pageSize: 1, isLoading: true),
            PaginatedList(
                list: [...Stub.pageOne, ...Stub.pageTwo],
                pageSize: 1,
                isLoading: false),
            PaginatedList(
                list: [...Stub.pageOne, ...Stub.pageTwo],
                pageSize: 1,
                isLoading: true),
            PaginatedList(
              list: [...Stub.pageOne, ...Stub.pageTwo, ...Stub.pageThree],
              pageSize: 1,
              isLoading: false,
            ),
          ],
        ),
      );
    });

    test('subject with null value', () {
      final pageSubject = BehaviorSubject<PaginatedList<int>>();

      final stream = Stream.fromIterable(<Result<PaginatedList<int>>>[
        Result.success(
          PaginatedList(list: Stub.pageTwo, pageSize: Stub.pageSize),
        ),
      ]);

      expectLater(
        stream.mergeWithPaginatedList(pageSubject),
        emitsInOrder(
          <PaginatedList<int>>[
            PaginatedList(list: Stub.pageTwo, pageSize: 1),
          ],
        ),
      );
    });
  });
}

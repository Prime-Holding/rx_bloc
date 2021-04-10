import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rx_bloc/rx_bloc.dart';

import 'stub.dart';

void main() {
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
      final snapshot = const AsyncSnapshot<PaginatedList<int>>.waiting();
      expect(snapshot.isInitialLoading, true);
    });

    test('isInitialLoading nothing', () async {
      final snapshot = const AsyncSnapshot<PaginatedList<int>>.nothing();
      expect(snapshot.isInitialLoading, true);
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
          onEvent: () => pageSubject.value!.reset(),
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
          onEvent: () => pageSubject.value!.reset(),
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

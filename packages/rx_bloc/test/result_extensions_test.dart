import 'package:rx_bloc/rx_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('Extension on Stream<T>.mapToResult()', () {
    test('mapToResult()', () async {
      await expectLater(
        Stream.value(0).mapToResult(),
        emitsInOrder([Result.success(0)]),
      );
    });

    test('mapToResult() with mapper callback', () async {
      await expectLater(
        Stream.value(1).mapToResult((value) => value * 10),
        emitsInOrder([Result.success(10)]),
      );
    });

    test('mapToResult() with mapper callback and tag', () async {
      await expectLater(
        Stream.value(1).mapToResult((value) => value * 10, 'tag'),
        emitsInOrder([Result.success(10, tag: 'tag')]),
      );
    });
  });

  group('Extension on Stream<T>.withLatestFromResult()', () {
    test('withLatestFromResult()', () async {
      await expectLater(
        Stream.value(0).withLatestFromResult<String>(
          Stream.value(Result.success('1')),
          (value, resultValue) => '$value, $resultValue',
        ),
        emitsInOrder([Result.success('0, 1')]),
      );
    });

    test('withLatestFromResult() with tag', () async {
      await expectLater(
        Stream.value(0).withLatestFromResult<String>(
            Stream.value(Result.success('1')),
            (value, resultValue) => '$value, $resultValue',
            tag: 'tag'),
        emitsInOrder([Result.success('0, 1', tag: 'tag')]),
      );
    });
  });

  group('ResultMapStream<E>', () {
    test('mapResult() loading, success, error', () async {
      await expectLater(
        Stream<Result<int>>.fromIterable([
          Result.loading(),
          Result.success(10),
          Result.error(Exception('1'))
        ])
            .mapResult((value) => value * 10)
            .asyncMapResult((value) async => value.toString()),
        emitsInOrder(<Result<String>>[
          Result.loading(),
          Result.success('100'),
          Result.error(Exception('1'))
        ]),
      );
    });

    test('mapResult() loading, success, error with tag', () async {
      await expectLater(
        Stream<Result<int>>.fromIterable([
          Result.loading(tag: '1'),
          Result.success(10, tag: '2'),
          Result.error(Exception('1'), tag: '3')
        ]).mapResult((value) => value * 10, tag: 'tag'),
        emitsInOrder(<Result<int>>[
          Result.loading(tag: 'tag'),
          Result.success(100, tag: 'tag'),
          Result.error(Exception('1'), tag: 'tag')
        ]),
      );
    });

    test('asyncMapResult() loading, success, error with tag', () async {
      await expectLater(
        Stream<Result<int>>.fromIterable([
          Result.loading(tag: '1'),
          Result.success(10, tag: '2'),
          Result.error(Exception('1'), tag: '3')
        ]).asyncMapResult((value) async => value * 10, tag: 'tag'),
        emitsInOrder(<Result<int>>[
          Result.loading(tag: 'tag'),
          Result.success(100, tag: 'tag'),
          Result.error(Exception('1'), tag: 'tag')
        ]),
      );
    });
  });
}

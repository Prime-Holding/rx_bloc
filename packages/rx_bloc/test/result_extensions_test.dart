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
        Stream.value(1).mapToResult(mapper: (data) => data * 10),
        emitsInOrder([Result.success(10)]),
      );
    });
  });

  group('Extension on Stream<T>.mapResultWithLatestFrom()', () {
    test('mapResultWithLatestFrom()', () async {
      await expectLater(
        Stream.value(0).mapResultWithLatestFrom<String>(
          Stream.value(Result.success('1')),
          (value, resultValue) => '$value, $resultValue',
        ),
        emitsInOrder([Result.success('0, 1')]),
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
  });
}

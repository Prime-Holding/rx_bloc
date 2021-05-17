import 'package:rx_bloc/rx_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('Extension on Stream<ResultError<T>>', () {
    test('mapToException()', () async {
      await expectLater(
        Stream.value(Result.error(Exception('test')) as ResultError)
            .mapToException()
            .map((exception) => exception.toString()),
        emitsInOrder(
          [
            'Exception: test',
          ],
        ),
      );
    });
  });

  group('Extension on Stream<Result<T>>', () {
    test('isLoadingWithTag()', () async {
      await expectLater(
        Stream.value(1).asResultStream(tag: 'tag').isLoadingWithTag(),
        emitsInOrder(
          [
            LoadingWithTag(loading: true, tag: 'tag'),
            LoadingWithTag(loading: false, tag: 'tag'),
          ],
        ),
      );
    });
    test('whereError()', () async {
      await expectLater(
        Stream.error(Exception('test'))
            .asResultStream()
            .whereError()
            .map((event) => event.toString()),
        emitsInOrder(
          [
            'Exception: test',
          ],
        ),
      );
    });

    test('whereSuccess()', () async {
      await expectLater(
        Stream.value('test').asResultStream().whereSuccess(),
        emitsInOrder(
          [
            'test',
          ],
        ),
      );
    });

    test('isLoading()', () async {
      await expectLater(
        Stream.value(1).asResultStream().isLoading(),
        emitsInOrder(
          [
            true,
            false,
          ],
        ),
      );
    });
  });

  group('Stream asResultStream', () {
    test('success case', () {
      expect(
          Stream.value(1).asResultStream(),
          emitsInOrder(
            [
              Result<int>.loading(),
              Result<int>.success(1),
            ],
          ));
    });

    test('error case', () {
      expect(
          Stream<int>.error(Exception('error')).asResultStream(),
          emitsInOrder(
            [
              Result<int>.loading(),
              Result<int>.error(Exception('error')),
            ],
          ));
    });
  });

  group('Future asResultStream', () {
    test('success case', () {
      expect(
          Future.delayed(
            const Duration(milliseconds: 300),
            () => Future.value(1),
          ).asResultStream(),
          emitsInOrder(
            [
              Result<int>.loading(),
              Result<int>.success(1),
            ],
          ));
    });

    test('error case', () {
      expect(
          Future<int>.error(Exception('error')).asResultStream(),
          emitsInOrder(
            [
              Result<int>.loading(),
              Result<int>.error(Exception('error')),
            ],
          ));
    });
  });
}

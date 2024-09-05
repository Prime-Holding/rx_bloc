import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/subjects.dart';
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

  group('Bind to subject', () {
    test('binds stream to subject', () async {
      // Create a BehaviorSubject to test the binding
      final subject = BehaviorSubject<int>();

      // Create a stream and bind it to the subject
      final stream = Stream.fromIterable([1, 2, 3]);
      final subscription = stream.bind(subject);

      // Collect the emitted values from the subject
      final emittedValues = <int>[];
      subject.listen(emittedValues.add);

      // Wait for the stream to complete
      await subscription.asFuture();
      await subscription.cancel();

      // Verify that the subject received the values from the stream
      expect(emittedValues, [1, 2, 3]);

      // Close the subject
      await subject.close();
    });
  });
}

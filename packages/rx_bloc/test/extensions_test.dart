import 'package:rx_bloc/rx_bloc.dart';
import 'package:test/test.dart';

void main() {
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

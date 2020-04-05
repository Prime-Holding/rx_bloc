import 'package:flutter_test/flutter_test.dart';
import 'package:rx_bloc/extensions.dart';
import 'package:rx_bloc/model/result.dart';

void main() {
  group("Stream asResultStream", () {
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

  group("Future asResultStream", () {
    test('success case', () {
      expect(
          Future.value(1).asResultStream(),
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

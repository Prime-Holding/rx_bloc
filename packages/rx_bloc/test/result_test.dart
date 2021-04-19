import 'package:rx_bloc/rx_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('Result<T>', () {
    test('positive equals', () {
      final result = Result<List<int>>.success([1, 2, 3]);
      final resultTwo = Result<List<int>>.success([1, 2, 3]);

      expect(result, equals(resultTwo));
    });

    test('negative equals', () {
      final result = Result<List<int>>.success([1, 2, 3]);
      final resultTwo = Result<List<int>>.success([1, 2]);

      expect(result, isNot(equals(resultTwo)));
    });
  });
}

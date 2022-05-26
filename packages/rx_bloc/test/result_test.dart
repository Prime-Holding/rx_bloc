import 'package:rx_bloc/rx_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('Result<String>', () {
    test('positive equals String', () {
      final result = Result<String>.success('1');
      final resultTwo = Result<String>.success('1');

      expect(result, equals(resultTwo));
    });

    test('negative equals String', () {
      final result = Result<String>.success('1');
      final resultTwo = Result<String>.success('2');

      expect(result, isNot(equals(resultTwo)));
    });
  });

  group('Result<List<T>>', () {
    test('positive equals List', () {
      final result = Result<List<int>>.success([1, 2, 3]);
      final resultTwo = Result<List<int>>.success([1, 2, 3]);

      expect(result, equals(resultTwo));
    });

    test('negative equals List', () {
      final result = Result<List<int>>.success([1, 2, 3]);
      final resultTwo = Result<List<int>>.success([1, 2]);

      expect(result, isNot(equals(resultTwo)));
    });
  });

  group('Result<Map<T>>', () {
    test('positive equals Map', () {
      final result = Result<Map<String, int>>.success({'a': 1, 'b': 2});
      final resultTwo = Result<Map<String, int>>.success({'a': 1, 'b': 2});

      expect(result, equals(equals(resultTwo)));
    });

    test('negative equals Map', () {
      final result = Result<Map<String, int>>.success({'a': 1, 'b': 2});
      final resultTwoA = Result<Map<String, int>>.success({'asd': 1, 'b': 2});

      expect(result, isNot(equals(resultTwoA)));

      final resultTwoB = Result<Map<String, int>>.success({'a': 2, 'b': 2});

      expect(result, isNot(equals(resultTwoB)));
    });
  });
}

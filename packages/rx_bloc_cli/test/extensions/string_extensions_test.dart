import 'package:rx_bloc_cli/src/extensions/string_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('test string_extensions matches', () {
    test('handles regular expressions as expected', () {
      final regex = '^([A-Za-z]{2,6})(\\.(?!-)[A-Za-z0-9-]{1,63}(?<!-))+\$';
      expect('com.example'.matches(regex: regex), isTrue);
      expect('non-matching'.matches(regex: regex), isFalse);
      expect('example.example'.matches(regex: regex), isFalse);
      expect('c.example'.matches(regex: regex), isFalse);
    });
  });
}

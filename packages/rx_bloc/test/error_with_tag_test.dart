import 'package:rx_bloc/src/model/error_with_tag.dart';
import 'package:test/test.dart';

void main() {
  group('Error With Tag', () {
    final exception = Exception('Exception message');
    const tag = 'tagName';

    test('ErrorWithTag with default tag', () async {
      expect(
        ErrorWithTag(exception: exception).toString(),
        '{loading: exception, tag: }',
      );
    });

    test('ErrorWithTag with custom tag', () async {
      expect(
        ErrorWithTag(exception: exception, tag: tag).toString(),
        '{loading: exception, tag: $tag}',
      );
    });

    test('ErrorWithTag equality', () async {
      final errorWithTag = ErrorWithTag(exception: exception, tag: tag);
      final errorWithTag2 = ErrorWithTag(exception: exception, tag: tag);

      expect(errorWithTag, equals(errorWithTag2));
      expect(errorWithTag.hashCode, errorWithTag2.hashCode);
    });
  });
}

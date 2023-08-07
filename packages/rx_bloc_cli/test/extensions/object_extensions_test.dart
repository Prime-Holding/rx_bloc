import 'package:rx_bloc_cli/src/extensions/object_extensions.dart';
import 'package:test/test.dart';

void main() {
  late Object sut;

  setUp(() {
    sut = 'string_value';
  });

  group('test object_extensions cast', () {
    test('should cast value to correct type', () {
      expect(sut.cast<String>(), equals('string_value'));
    });

    test('should throw error if incorrect type', () {
      expect(() => sut.cast<int>(), throwsA(isA<TypeError>()));
    });
  });
}

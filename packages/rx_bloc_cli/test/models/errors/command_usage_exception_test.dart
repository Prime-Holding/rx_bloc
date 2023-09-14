import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';
import 'package:test/test.dart';

void main() {
  late CommandUsageException sut;

  group('test command_usage_exception', () {
    test('should return error message when toString is invoked', () {
      final message = 'Message to verify';
      sut = CommandUsageException(message);

      expect(sut.toString(), equals(message));
    });
  });
}

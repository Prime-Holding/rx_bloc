import 'package:args/args.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_cli/src/extensions/arg_results_extensions.dart';
import 'package:rx_bloc_cli/src/models/command_arguments.dart';
import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';
import 'package:test/test.dart';
import 'arg_results_extensions_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ArgResults>(),
])
void main() {
  late MockArgResults sut;

  setUp(() {
    sut = MockArgResults();
  });

  group('test arg_results interactiveConfigurationEnabled', () {
    test('should return provided value if present', () {
      final value = !CommandArguments.interactive.defaultValue<bool>();
      when(sut[CommandArguments.interactive.name]).thenReturn(value.toString());

      expect(sut.interactiveConfigurationEnabled, equals(value));
    });

    test('should return default value if no value provided', () {
      final value = CommandArguments.interactive.defaultValue<bool>();
      when(sut[CommandArguments.interactive.name]).thenReturn(null);

      expect(sut.interactiveConfigurationEnabled, equals(value));
    });
  });

  group('test arg_results outputDirectory', () {
    test('should return directory if provided', () {
      when(sut.rest).thenReturn(['testDirectory']);
      expect(sut.outputDirectory.path, equals('testDirectory'));
    });
    
    test('should throw error if no directory provided', () {
      when(sut.rest).thenReturn([]);
      expect(() => sut.outputDirectory, throwsA(isA<CommandUsageException>()));
    });

    test('should throw error if multiple directories provided', () {
      when(sut.rest).thenReturn(['value1', 'value2']);
      expect(() => sut.outputDirectory, throwsA(isA<CommandUsageException>()));
    });
  });
}

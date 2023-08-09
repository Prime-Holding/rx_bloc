import 'package:args/args.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_cli/src/extensions/arg_results_extensions.dart';
import 'package:rx_bloc_cli/src/models/command_arguments.dart';
import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';
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
      when(sut[CommandArguments.interactive.name]).thenReturn(value);

      expect(sut.interactiveConfigurationEnabled, equals(value));
    });

    test('should throw exception if no value available', () {
      final value = CommandArguments.interactive.defaultValue<bool>();
      when(sut[CommandArguments.interactive.name]).thenReturn(null);

      expect(
          () => sut.interactiveConfigurationEnabled, throwsA(isA<TypeError>()));
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

  group('test arg_results readString', () {
    test('should return string for the correct type', () {
      final projectName = CommandArguments.projectName;
      final organisation = CommandArguments.organisation;
      when(sut[projectName.name]).thenReturn('testapp');
      when(sut[organisation.name]).thenReturn(null);

      expect(sut.readString(projectName), equals('testapp'));
      expect(sut.readString(organisation), organisation.defaultValue());
    });

    test('should throw error for incorrect type', () {
      expect(
          () => sut.readString(CommandArguments.otp), throwsUnsupportedError);
    });
  });

  group('test arg_results readBool', () {
    test('should return bool for the correct type', () {
      final enableLogin = CommandArguments.login;
      when(sut[enableLogin.name]).thenReturn(false);

      expect(sut.readBool(enableLogin), isFalse);
    });

    test('should throw error for incorrect type', () {
      expect(() => sut.readBool(CommandArguments.projectName),
          throwsUnsupportedError);
    });
  });

  group('test arg_results readRealtimeCommunicationType', () {
    test('should return RealtimeCommunicationType for the correct type', () {
      final realtimeCommunication = CommandArguments.realtimeCommunication;
      when(sut[realtimeCommunication.name])
          .thenReturn(RealtimeCommunicationType.sse.name);

      expect(sut.readRealtimeCommunicationType(realtimeCommunication),
          equals(RealtimeCommunicationType.sse));

      when(sut[realtimeCommunication.name]).thenReturn(null);
      expect(sut.readRealtimeCommunicationType(realtimeCommunication),
          realtimeCommunication.defaultValue());
    });

    test('should throw error for incorrect type', () {
      expect(
          () => sut.readRealtimeCommunicationType(CommandArguments.projectName),
          throwsUnsupportedError);
    });
  });
}

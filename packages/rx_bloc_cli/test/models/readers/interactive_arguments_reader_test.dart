import 'package:mason/mason.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_cli/src/models/command_arguments.dart';
import 'package:rx_bloc_cli/src/models/readers/interactive_arguments_reader.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';
import 'package:test/test.dart';

import 'interactive_arguments_reader_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
])
void main() {
  late MockLogger logger;
  late InteractiveArgumentsReader sut;

  setUp(() {
    logger = MockLogger();
    sut = InteractiveArgumentsReader(logger);
  });

  group('test interactive_argument_reader readString', () {
    test('should return value for mandatory argument', () {
      final argument = CommandArguments.projectName;
      when(logger.prompt(argument.prompt)).thenReturn('testapp');

      expect(sut.readString(argument), equals('testapp'));
    });

    test('should return value for optional argument', () {
      final argument = CommandArguments.organisation;
      when(logger.prompt(argument.prompt, defaultValue: argument.defaultsTo))
          .thenReturn(argument.defaultValue());

      expect(sut.readString(argument), equals(argument.defaultValue()));
    });

    test('should throw exception if wrong type is provided', () {
      final argument = CommandArguments.login;

      expect(() => sut.readString(argument), throwsUnsupportedError);
    });
  });

  group('test interactive_argument_reader readBool', () {
    test('should return value for argument', () {
      final argument = CommandArguments.otp;
      when(logger.confirm(argument.prompt,
              defaultValue: argument.defaultValue()))
          .thenReturn(true);

      expect(sut.readBool(argument), isTrue);
    });

    test('should throw exception if wrong type is provided', () {
      final argument = CommandArguments.realtimeCommunication;

      expect(() => sut.readBool(argument), throwsUnsupportedError);
    });
  });

  group('test interactive_argument_reader readRealtimeCommunicationEnum', () {
    test('should return value for correct argument', () {
      when(logger.prompt(any,
              defaultValue: CommandArguments.realtimeCommunication.defaultsTo))
          .thenReturn('none');
      final value = sut.readRealtimeCommunicationEnum(
          CommandArguments.realtimeCommunication);
      expect(value, equals(RealtimeCommunicationType.none));
    });

    test('should throw error for incorrect argument type', () {
      final argument = CommandArguments.organisation;
      expect(
        () => sut.readRealtimeCommunicationEnum(argument),
        throwsUnsupportedError,
      );
    });

    test('should throw error for incorrectly provided value', () {
      when(logger.prompt(any,
              defaultValue: CommandArguments.realtimeCommunication.defaultsTo))
          .thenReturn('incorrect_case');

      final argument = CommandArguments.realtimeCommunication;
      expect(
        () => sut.readRealtimeCommunicationEnum(argument),
        throwsUnsupportedError,
      );
    });
  });

  group('test interactive_argument_reader isSupported', () {
    test('should only support arguments with interactive input', () {
      for (var argument in CommandArguments.values) {
        expect(sut.isSupported(argument),
            equals(argument.supportsInteractiveInput));
      }
    });
  });

  group('test interactive_argument_reader read', () {
    test('should throw error if not supported', () {
      expect(() => sut.read<String>(CommandArguments.interactive),
          throwsUnsupportedError);
    });

    test('should return handle string arguments correctly', () {
      final argument = CommandArguments.organisation;
      when(logger.prompt(any, defaultValue: argument.defaultsTo))
          .thenReturn('com.example');
      expect(sut.read<String>(argument), equals('com.example'));
      expect(() => sut.read<int>(argument), throwsA(isA<TypeError>()));
    });

    test('should return handle bool arguments correctly', () {
      final argument = CommandArguments.otp;
      when(logger.confirm(any, defaultValue: argument.defaultValue()))
          .thenReturn(true);
      expect(sut.read<bool>(argument), isTrue);
      expect(() => sut.read<int>(argument), throwsA(isA<TypeError>()));
    });

    test('should return handle realtime communication arguments correctly', () {
      final argument = CommandArguments.realtimeCommunication;
      when(logger.prompt(any, defaultValue: argument.defaultsTo))
          .thenReturn('none');
      expect(sut.read<RealtimeCommunicationType>(argument),
          RealtimeCommunicationType.none);
      expect(() => sut.read<int>(argument), throwsA(isA<TypeError>()));
    });

    test('should execute validation if provided', () {
      final argument = CommandArguments.organisation;
      when(logger.prompt(any, defaultValue: argument.defaultsTo))
          .thenReturn('com.example');

      var executed = false;

      final _ = sut.read<String>(argument, validation: (value) {
        executed = true;
        return value;
      });
      expect(executed, isTrue);
    });
  });
}

import 'package:mason/mason.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_cli/src/models/ci_cd_type.dart';
import 'package:rx_bloc_cli/src/models/command_arguments/create_command_arguments.dart';
import 'package:rx_bloc_cli/src/models/readers/interactive_arguments_reader.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';
import 'package:test/test.dart';

import '../../stub.dart';
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
      final argument = CreateCommandArguments.projectName;
      when(logger.prompt(argument.prompt)).thenReturn(Stub.projectName);

      expect(sut.readString(argument), equals(Stub.projectName));
    });

    test('should return value for optional argument', () {
      final argument = CreateCommandArguments.organisation;
      when(logger.prompt(argument.prompt, defaultValue: argument.defaultsTo))
          .thenReturn(argument.defaultValue());

      expect(sut.readString(argument), equals(argument.defaultValue()));
    });

    test('should throw exception if wrong type is provided', () {
      final argument = CreateCommandArguments.login;

      expect(() => sut.readString(argument), throwsUnsupportedError);
    });
  });

  group('test interactive_argument_reader readBool', () {
    test('should return value for argument', () {
      final argument = CreateCommandArguments.otp;
      when(logger.confirm(argument.prompt,
              defaultValue: argument.defaultValue()))
          .thenReturn(true);

      expect(sut.readBool(argument), isTrue);
    });

    test('should throw exception if wrong type is provided', () {
      final argument = CreateCommandArguments.realtimeCommunication;

      expect(() => sut.readBool(argument), throwsUnsupportedError);
    });
  });

  group('test interactive_argument_reader readRealtimeCommunicationEnum', () {
    test('should return value for correct argument', () {
      when(logger.prompt(any,
              defaultValue:
                  CreateCommandArguments.realtimeCommunication.defaultsTo))
          .thenReturn(RealtimeCommunicationType.none.name);
      final value = sut.readRealtimeCommunicationEnum(
          CreateCommandArguments.realtimeCommunication);
      expect(value, equals(RealtimeCommunicationType.none));
    });

    test('should throw error for incorrect argument type', () {
      final argument = CreateCommandArguments.organisation;
      expect(
        () => sut.readRealtimeCommunicationEnum(argument),
        throwsUnsupportedError,
      );
    });

    test('should throw error for incorrectly provided value', () {
      when(logger.prompt(any,
              defaultValue:
                  CreateCommandArguments.realtimeCommunication.defaultsTo))
          .thenReturn(Stub.incorrectRealtimeCommunicationCase);

      final argument = CreateCommandArguments.realtimeCommunication;
      expect(
        () => sut.readRealtimeCommunicationEnum(argument),
        throwsUnsupportedError,
      );
    });
  });

  group('test interactive_argument_reader isSupported', () {
    test('should only support arguments with interactive input', () {
      for (var argument in CreateCommandArguments.values) {
        expect(sut.isSupported(argument),
            equals(argument.supportsInteractiveInput));
      }
    });
  });

  group('test interactive_argument_reader read', () {
    test('should throw error if not supported', () {
      expect(() => sut.read<String>(CreateCommandArguments.interactive),
          throwsUnsupportedError);
    });

    test('should return handle string arguments correctly', () {
      final argument = CreateCommandArguments.organisation;
      when(logger.prompt(any, defaultValue: argument.defaultsTo))
          .thenReturn(Stub.organisation);
      expect(sut.read<String>(argument), equals(Stub.organisation));
      expect(() => sut.read<int>(argument), throwsA(isA<TypeError>()));
    });

    test('should return handle bool arguments correctly', () {
      final argument = CreateCommandArguments.otp;
      when(logger.confirm(any, defaultValue: argument.defaultValue()))
          .thenReturn(true);
      expect(sut.read<bool>(argument), isTrue);
      expect(() => sut.read<int>(argument), throwsA(isA<TypeError>()));
    });

    test('should return handle realtime communication arguments correctly', () {
      final argument = CreateCommandArguments.realtimeCommunication;
      when(logger.prompt(any, defaultValue: argument.defaultsTo))
          .thenReturn(RealtimeCommunicationType.none.name);
      expect(sut.read<RealtimeCommunicationType>(argument),
          RealtimeCommunicationType.none);
      expect(() => sut.read<int>(argument), throwsA(isA<TypeError>()));
    });

    test('should execute validation if provided', () {
      final argument = CreateCommandArguments.organisation;
      when(logger.prompt(any, defaultValue: argument.defaultsTo))
          .thenReturn(argument.defaultValue());

      var executed = false;

      final _ = sut.read<String>(argument, validation: (value) {
        executed = true;
        return value;
      });
      expect(executed, isTrue);
    });
  });

  group('test interactive_argument_reader readCICDEnum', () {
    test('should return value for correct argument', () {
      when(logger.prompt(any,
              defaultValue: CreateCommandArguments.cicd.defaultsTo))
          .thenReturn(CICDType.fastlane.name);
      final value = sut.readCICDEnum(CreateCommandArguments.cicd);
      expect(value, equals(CICDType.fastlane));
      expect(
        sut.read<CICDType>(CreateCommandArguments.cicd),
        CICDType.fastlane,
      );
    });

    test('should throw error for incorrect argument type', () {
      final argument = CreateCommandArguments.organisation;
      expect(
        () => sut.readCICDEnum(argument),
        throwsUnsupportedError,
      );
    });

    test('should throw error for incorrectly provided value', () {
      when(logger.prompt(any,
              defaultValue: CreateCommandArguments.cicd.defaultsTo))
          .thenReturn(Stub.incorrectCICDTypeCase);

      final argument = CreateCommandArguments.cicd;
      expect(
        () => sut.readCICDEnum(argument),
        throwsUnsupportedError,
      );
    });
  });
}

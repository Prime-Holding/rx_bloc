import 'package:args/args.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_cli/src/models/ci_cd_type.dart';
import 'package:rx_bloc_cli/src/models/command_arguments/create_command_arguments.dart';
import 'package:rx_bloc_cli/src/models/readers/non_interactive_arguments_reader.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';
import 'package:test/test.dart';

import '../../stub.dart';
import 'non_interactive_arguments_reader_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ArgResults>(),
])
void main() {
  late MockArgResults argResults;
  late NonInteractiveArgumentsReader sut;

  setUp(() {
    argResults = MockArgResults();
    sut = NonInteractiveArgumentsReader(argResults);
  });

  group('test non_interactive_argument_reader readString', () {
    test('should return value for mandatory argument', () {
      final argument = CreateCommandArguments.projectName;
      when(argResults[argument.name]).thenReturn(Stub.projectName);

      expect(sut.readString(argument), equals(Stub.projectName));
    });

    test('should return value for optional argument', () {
      final argument = CreateCommandArguments.organisation;
      when(argResults[argument.name]).thenReturn(Stub.organisation);

      expect(sut.readString(argument), equals(Stub.organisation));
    });
  });

  group('test non_interactive_argument_reader readBool', () {
    test('should return value for optional argument', () {
      final argument = CreateCommandArguments.otp;
      when(argResults[argument.name]).thenReturn(true);

      expect(sut.readBool(argument), isTrue);
    });
  });

  group('test non_interactive_argument_reader readRealtimeCommunicationEnum',
      () {
    test('should return value for correct argument', () {
      when(argResults[CreateCommandArguments.realtimeCommunication.name])
          .thenReturn(RealtimeCommunicationType.none.name);
      final value = sut.readRealtimeCommunicationEnum(
          CreateCommandArguments.realtimeCommunication);
      expect(value, equals(RealtimeCommunicationType.none));
    });

    test('should throw error for incorrect argument', () {
      final wrongCommandArgument = CreateCommandArguments.otp;
      expect(() => sut.readRealtimeCommunicationEnum(wrongCommandArgument),
          throwsUnsupportedError);
    });
  });

  group('test non_interactive_argument_reader isSupported', () {
    test('should only support arguments with interactive input', () {
      for (var argument in CreateCommandArguments.values) {
        expect(sut.isSupported(argument), isTrue);
      }
    });
  });

  group('test non_interactive_argument_reader read', () {
    test('should return handle string arguments correctly', () {
      final argument = CreateCommandArguments.organisation;
      when(argResults[argument.name]).thenReturn(Stub.organisation);
      expect(sut.read<String>(argument), equals(Stub.organisation));
      expect(() => sut.read<int>(argument), throwsA(isA<TypeError>()));
    });

    test('should return handle bool arguments correctly', () {
      final argument = CreateCommandArguments.otp;
      when(argResults[argument.name]).thenReturn(true);
      expect(sut.read<bool>(argument), isTrue);
      expect(() => sut.read<int>(argument), throwsA(isA<TypeError>()));
    });

    test('should return handle realtime communication arguments correctly', () {
      final argument = CreateCommandArguments.realtimeCommunication;
      when(argResults[argument.name])
          .thenReturn(RealtimeCommunicationType.none.name);
      expect(sut.read<RealtimeCommunicationType>(argument),
          RealtimeCommunicationType.none);
      expect(() => sut.read<int>(argument), throwsA(isA<TypeError>()));
    });

    test('should execute validation if provided', () {
      final argument = CreateCommandArguments.organisation;
      when(argResults[argument.name]).thenReturn(Stub.organisation);

      var executed = false;

      final _ = sut.read<String>(argument, validation: (value) {
        executed = true;
        return value;
      });
      expect(executed, isTrue);
    });

    test('test readCICDEnum should return value for correct argument', () {
      when(argResults[CreateCommandArguments.cicd.name])
          .thenReturn(CICDType.fastlane.name);
      final value = sut.readCICDEnum(CreateCommandArguments.cicd);
      expect(value, equals(CICDType.fastlane));
    });
  });
}

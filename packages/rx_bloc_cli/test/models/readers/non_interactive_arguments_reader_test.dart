import 'package:args/args.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_cli/src/models/command_arguments.dart';
import 'package:rx_bloc_cli/src/models/readers/non_interactive_arguments_reader.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';
import 'package:test/test.dart';

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
      final argument = CommandArguments.projectName;
      when(argResults[argument.name]).thenReturn('testapp');

      expect(sut.readString(argument), equals('testapp'));
    });

    test('should return value for optional argument', () {
      final argument = CommandArguments.organisation;
      when(argResults[argument.name]).thenReturn('com.example');

      expect(sut.readString(argument), equals('com.example'));
    });
  });

  group('test non_interactive_argument_reader readBool', () {
    test('should return value for optional argument', () {
      final argument = CommandArguments.otp;
      when(argResults[argument.name]).thenReturn(true);

      expect(sut.readBool(argument), isTrue);
    });
  });

  group('test non_interactive_argument_reader readRealtimeCommunicationEnum',
      () {
    test('should return value for correct argument', () {
      when(argResults[CommandArguments.realtimeCommunication.name])
          .thenReturn(RealtimeCommunicationType.none.name);
      final value = sut.readRealtimeCommunicationEnum(
          CommandArguments.realtimeCommunication);
      expect(value, equals(RealtimeCommunicationType.none));
    });

    test('should throw error for incorrect argument', () {
      final wrongCommandArgument = CommandArguments.otp;
      expect(() => sut.readRealtimeCommunicationEnum(wrongCommandArgument),
          throwsUnsupportedError);
    });
  });

  group('test non_interactive_argument_reader isSupported', () {
    test('should only support arguments with interactive input', () {
      for (var argument in CommandArguments.values) {
        expect(sut.isSupported(argument), isTrue);
      }
    });
  });

  group('test non_interactive_argument_reader read', () {
    test('should return handle string arguments correctly', () {
      final argument = CommandArguments.organisation;
      when(argResults[argument.name]).thenReturn('com.example');
      expect(sut.read<String>(argument), equals('com.example'));
      expect(() => sut.read<int>(argument), throwsA(isA<TypeError>()));
    });

    test('should return handle bool arguments correctly', () {
      final argument = CommandArguments.otp;
      when(argResults[argument.name]).thenReturn(true);
      expect(sut.read<bool>(argument), isTrue);
      expect(() => sut.read<int>(argument), throwsA(isA<TypeError>()));
    });

    test('should return handle realtime communication arguments correctly', () {
      final argument = CommandArguments.realtimeCommunication;
      when(argResults[argument.name])
          .thenReturn(RealtimeCommunicationType.none.name);
      expect(sut.read<RealtimeCommunicationType>(argument),
          RealtimeCommunicationType.none);
      expect(() => sut.read<int>(argument), throwsA(isA<TypeError>()));
    });

    test('should execute validation if provided', () {
      final argument = CommandArguments.organisation;
      when(argResults[argument.name]).thenReturn('com.example');

      var executed = false;

      final _ = sut.read<String>(argument, validation: (value) {
        executed = true;
        return value;
      });
      expect(executed, isTrue);
    });
  });
}

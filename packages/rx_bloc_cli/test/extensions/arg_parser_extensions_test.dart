import 'package:args/args.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_cli/src/extensions/arg_parser_extensions.dart';
import 'package:rx_bloc_cli/src/models/command_arguments.dart';
import 'package:test/test.dart';

import 'arg_parser_extensions_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ArgParser>(),
])
void main() {
  late MockArgParser sut;

  setUp(() {
    sut = MockArgParser();
  });

  group('test arg_parser_extensions addCommandArguments', () {
    test('should call addOption with all values', () {
      when(
        sut.addOption(
          any,
          help: anyNamed('help'),
          defaultsTo: anyNamed('defaultsTo'),
          allowed: anyNamed('allowed'),
          mandatory: anyNamed('mandatory'),
        ),
      ).thenReturn(null);

      verifyNever(
        sut.addOption(
          any,
          help: anyNamed('help'),
          defaultsTo: anyNamed('defaultsTo'),
          allowed: anyNamed('allowed'),
          mandatory: anyNamed('mandatory'),
        ),
      );
      verifyNever(
        sut.addFlag(
          any,
          help: anyNamed('help'),
          defaultsTo: anyNamed('defaultsTo'),
          negatable: true,
        ),
      );

      final arguments = CommandArguments.values;
      sut.addCommandArguments(arguments);

      final expectedAddOptionCalls =
          arguments.where((arg) => arg.type != ArgumentType.boolean).length;
      final expectedAddFlagCalls =
          arguments.where((arg) => arg.type == ArgumentType.boolean).length;
      verify(
        sut.addOption(
          any,
          help: anyNamed('help'),
          defaultsTo: anyNamed('defaultsTo'),
          allowed: anyNamed('allowed'),
          mandatory: anyNamed('mandatory'),
        ),
      ).called(expectedAddOptionCalls);
      verify(
        sut.addFlag(
          any,
          help: anyNamed('help'),
          defaultsTo: anyNamed('defaultsTo'),
          negatable: true,
        ),
      ).called(expectedAddFlagCalls);
    });
  });
}

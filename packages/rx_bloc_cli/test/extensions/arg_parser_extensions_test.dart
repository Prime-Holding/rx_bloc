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

      final arguments = CommandArguments.values;
      sut.addCommandArguments(arguments);

      verify(
        sut.addOption(
          any,
          help: anyNamed('help'),
          defaultsTo: anyNamed('defaultsTo'),
          allowed: anyNamed('allowed'),
          mandatory: anyNamed('mandatory'),
        ),
      ).called(arguments.length);
    });
  });
}

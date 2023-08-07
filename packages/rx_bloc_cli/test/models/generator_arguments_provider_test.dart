import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_cli/src/models/command_arguments.dart';
import 'package:rx_bloc_cli/src/models/configurations/project_configuration.dart';
import 'package:rx_bloc_cli/src/models/generator_arguments_provider.dart';
import 'package:rx_bloc_cli/src/models/readers/command_arguments_reader.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';
import 'package:test/test.dart';

import '../stub.dart';
import 'generator_arguments_provider_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CommandArgumentsReader>(),
  MockSpec<Logger>(),
])
void main() {
  late Directory outputDirectory;
  late MockCommandArgumentsReader reader;
  late MockLogger logger;
  late GeneratorArgumentsProvider sut;
  late Map<String, Object> argumentValues;

  setUp(() {
    outputDirectory = Directory('directory_path');
    reader = MockCommandArgumentsReader();
    logger = MockLogger();
    sut = GeneratorArgumentsProvider(outputDirectory, reader, logger);

    provideDummyBuilder<String>((parent, invocation) {
      final argument = invocation.positionalArguments.first;

      if (argument is CommandArguments) {
        return argumentValues[argument.name] as String;
      }

      throw UnsupportedError('No dummy builder for $invocation');
    });

    provideDummyBuilder<bool>((parent, invocation) {
      final argument = invocation.positionalArguments.first;

      if (argument is CommandArguments) {
        return argumentValues[argument.name] as bool;
      }

      throw UnsupportedError('No dummy builder for $invocation');
    });

    provideDummyBuilder<RealtimeCommunicationType>((parent, invocation) {
      final argument = invocation.positionalArguments.first;

      if (argument is CommandArguments) {
        return argumentValues[argument.name] as RealtimeCommunicationType;
      }

      throw UnsupportedError('No dummy builder for $invocation');
    });
  });

  void configure(Map<String, Object> values) {
    argumentValues = values;
  };

  group('test generator_arguments_provider read', () {
    test('should return generator_arguments with valid configuration', () {
      configure(Stub.defaultValues);
      expect(() => sut.readGeneratorArguments(), returnsNormally);
    });
  });
}

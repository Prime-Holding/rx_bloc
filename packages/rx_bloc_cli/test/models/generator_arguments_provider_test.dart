import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_cli/src/models/command_arguments.dart';
import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';
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

  T buildDummyValues<T extends Object>(Object parent, Invocation invocation) {
    final readSymbol = const Symbol('read');
    final validationSymbol = const Symbol('validation');

    if (invocation.memberName == readSymbol) {
      final argument = invocation.positionalArguments.first as CommandArguments;
      final validation =
          invocation.namedArguments[validationSymbol] as T Function(T)?;
      final value = argumentValues[argument.name] as T;

      return validation != null ? validation(value) : value;
    }

    throw UnsupportedError('No dummy builder for $invocation');
  }

  setUp(() {
    outputDirectory = Directory('directory_path');
    reader = MockCommandArgumentsReader();
    logger = MockLogger();
    sut = GeneratorArgumentsProvider(outputDirectory, reader, logger);

    // Each supported type must have a dummy builder
    provideDummyBuilder<String>(buildDummyValues);
    provideDummyBuilder<bool>(buildDummyValues);
    provideDummyBuilder<RealtimeCommunicationType>(buildDummyValues);
  });

  void configureArgumentValues(Map<String, Object> values) {
    argumentValues = values;
  }

  group('test generator_arguments_provider read', () {
    test('should return generator_arguments with valid configuration', () {
      configureArgumentValues(Stub.defaultValues);
      expect(() => sut.readGeneratorArguments(), returnsNormally);
    });

    test('should throw error if projectName is invalid', () {
      configureArgumentValues(Stub.invalidProjectNameValues);
      expect(() => sut.readGeneratorArguments(),
          throwsA(isA<CommandUsageException>()));
    });

    test('should throw error if organisation is invalid', () {
      configureArgumentValues(Stub.invalidOrganisationValues);
      expect(() => sut.readGeneratorArguments(),
          throwsA(isA<CommandUsageException>()));
    });

    test('should return updated values if configuration is not valid', () {
      configureArgumentValues(Stub.invalidAuthConfigurationValues);

      verifyNever(logger.warn(any));
      final generatorArguments = sut.readGeneratorArguments();

      expect(generatorArguments.otpEnabled, isTrue);
      expect(generatorArguments.loginEnabled, isTrue);

      verify(logger.warn(any)).called(1);
    });
  });
}

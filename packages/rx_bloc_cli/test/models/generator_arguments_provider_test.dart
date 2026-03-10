import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_cli/src/models/ci_cd_type.dart';
import 'package:rx_bloc_cli/src/models/command_arguments/create_command_arguments.dart';
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
      final argument =
          invocation.positionalArguments.first as CreateCommandArguments;
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
    provideDummyBuilder<CICDType>(buildDummyValues);
  });

  void configureArgumentValues(Map<String, Object> values) {
    argumentValues = values;
  }

  group('test generator_arguments_provider read', () {
    test('should return generator_arguments with valid configuration', () {
      configureArgumentValues(Stub.defaultValues);
      expect(() => sut.readGeneratorArguments(), returnsNormally);
    });

    test('should preserve default values and output directory', () {
      configureArgumentValues(Stub.defaultValues);

      final generatorArguments = sut.readGeneratorArguments();

      expect(generatorArguments.outputDirectory.path, outputDirectory.path);
      expect(generatorArguments.projectName, Stub.projectName);
      expect(generatorArguments.organisation,
          CreateCommandArguments.organisation.defaultValue<String>());
      expect(generatorArguments.changeLanguageEnabled, isTrue);
      expect(generatorArguments.pushNotificationsEnabled, isTrue);
      expect(generatorArguments.realtimeCommunicationEnabled, isFalse);
      expect(generatorArguments.cicdEnabled, isTrue);
      expect(generatorArguments.cicdGithubEnabled, isFalse);
      expect(generatorArguments.cicdCodemagicEnabled, isFalse);
      expect(generatorArguments.widgetToolkitEnabled, isFalse);

      verifyNever(logger.warn(any));
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
      expect(generatorArguments.pinCodeEnabled, isFalse);

      verify(logger.warn(any)).called(1);
    });

    test('should return updated values if mfa is enabled', () {
      configureArgumentValues(Stub.mfaEnabled);

      verifyNever(logger.warn(any));
      final generatorArguments = sut.readGeneratorArguments();

      expect(generatorArguments.otpEnabled, isTrue);
      expect(generatorArguments.pinCodeEnabled, isTrue);
      expect(generatorArguments.mfaEnabled, isTrue);

      verify(logger.warn(any)).called(3);
    });

    test('should return updated values if changeLanguage is enabled', () {
      configureArgumentValues(Stub.changeLanguageEnabled);

      verifyNever(logger.warn(any));
      final generatorArguments = sut.readGeneratorArguments();

      expect(generatorArguments.profileEnabled, isTrue);
      expect(generatorArguments.changeLanguageEnabled, isTrue);

      verify(logger.warn(any)).called(1);
    });

    test('should return updated values if login is enabled', () {
      configureArgumentValues(Stub.loginEnabled);

      verifyNever(logger.warn(any));
      final generatorArguments = sut.readGeneratorArguments();

      expect(generatorArguments.profileEnabled, isTrue);
      expect(generatorArguments.loginEnabled, isTrue);

      verify(logger.warn(any)).called(1);
    });

    test('should return updated values if onboarding is enabled', () {
      configureArgumentValues(Stub.onboardingEnabled);

      verifyNever(logger.warn(any));
      final generatorArguments = sut.readGeneratorArguments();

      expect(generatorArguments.profileEnabled, isTrue);
      expect(generatorArguments.loginEnabled, isTrue);
      expect(generatorArguments.deepLinkEnabled, isTrue);
      expect(generatorArguments.onboardingEnabled, isTrue);

      verify(logger.warn(any)).called(3);
    });

    test(
      'should keep login disabled when social logins satisfy onboarding '
      'dependency',
      () {
        configureArgumentValues(Map<String, Object>.from(Stub.defaultValues)
          ..[CreateCommandArguments.onboarding.name] = true
          ..[CreateCommandArguments.login.name] = false
          ..[CreateCommandArguments.socialLogins.name] = true
          ..[CreateCommandArguments.profile.name] = false
          ..[CreateCommandArguments.deepLink.name] = false);

        final generatorArguments = sut.readGeneratorArguments();

        expect(generatorArguments.loginEnabled, isFalse);
        expect(generatorArguments.socialLoginsEnabled, isTrue);
        expect(generatorArguments.profileEnabled, isTrue);
        expect(generatorArguments.deepLinkEnabled, isTrue);

        verifyNever(logger.warn(
          'Login enabled, due to OTP/PIN/Onboarding/Forgotten Password feature requirement',
        ));
        verify(logger.warn(
          'Profile enabled, due to authentication feature requirement',
        )).called(1);
        verify(logger.warn(
          'Deep links enabled, due to Onboarding feature requirement',
        )).called(1);
        verifyNoMoreInteractions(logger);
      },
    );

    test('should return updated values if forgotten pass is enabled', () {
      configureArgumentValues(Stub.forgottenPassEnabled);

      verifyNever(logger.warn(any));
      final generatorArguments = sut.readGeneratorArguments();

      expect(generatorArguments.profileEnabled, isTrue);
      expect(generatorArguments.loginEnabled, isTrue);
      expect(generatorArguments.deepLinkEnabled, isTrue);
      expect(generatorArguments.onboardingEnabled, isTrue);
      expect(generatorArguments.forgottenPassword, isTrue);

      verify(logger.warn(any)).called(4);
    });

    test(
      'should enable realtime communication and widget toolkit '
      'for in-app notifications',
      () {
        configureArgumentValues(Map<String, Object>.from(Stub.defaultValues)
          ..[CreateCommandArguments.inAppNotifications.name] = true
          ..[CreateCommandArguments.realtimeCommunication.name] =
              RealtimeCommunicationType.none
          ..[CreateCommandArguments.widgetToolkit.name] = false);

        final generatorArguments = sut.readGeneratorArguments();

        expect(generatorArguments.inAppNotificationsEnabled, isTrue);
        expect(generatorArguments.realtimeCommunicationEnabled, isTrue);
        expect(generatorArguments.widgetToolkitEnabled, isTrue);

        verify(logger.warn(
          'Realtime communication enabled, due to In-app notifications '
          'feature requirement',
        )).called(1);
        verify(logger.warn(
          'Widget toolkit enabled, due to In-app notifications '
          'feature requirement',
        )).called(1);
        verifyNoMoreInteractions(logger);
      },
    );

    test('should map realtime communication enum to enabled flag', () {
      configureArgumentValues(Map<String, Object>.from(Stub.defaultValues)
        ..[CreateCommandArguments.realtimeCommunication.name] =
            RealtimeCommunicationType.sse);

      final generatorArguments = sut.readGeneratorArguments();

      expect(generatorArguments.realtimeCommunicationEnabled, isTrue);
      verifyNever(logger.warn(any));
    });

    test(
      'should disable cicd flags when no provider is selected',
      () {
        configureArgumentValues(Map<String, Object>.from(Stub.defaultValues)
          ..[CreateCommandArguments.cicd.name] = CICDType.none);

        final generatorArguments = sut.readGeneratorArguments();

        expect(generatorArguments.cicdEnabled, isFalse);
        expect(generatorArguments.cicdGithubEnabled, isFalse);
        expect(generatorArguments.cicdCodemagicEnabled, isFalse);
        verifyNever(logger.warn(any));
      },
    );

    test(
      'should map github cicd type to github flag only',
      () {
        configureArgumentValues(Map<String, Object>.from(Stub.defaultValues)
          ..[CreateCommandArguments.cicd.name] = CICDType.github);

        final generatorArguments = sut.readGeneratorArguments();

        expect(generatorArguments.cicdEnabled, isTrue);
        expect(generatorArguments.cicdGithubEnabled, isTrue);
        expect(generatorArguments.cicdCodemagicEnabled, isFalse);
        verifyNever(logger.warn(any));
      },
    );

    test('should map codemagic cicd type to codemagic flag only', () {
      configureArgumentValues(Map<String, Object>.from(Stub.defaultValues)
        ..[CreateCommandArguments.cicd.name] = CICDType.codemagic);

      final generatorArguments = sut.readGeneratorArguments();

      expect(generatorArguments.cicdEnabled, isTrue);
      expect(generatorArguments.cicdGithubEnabled, isFalse);
      expect(generatorArguments.cicdCodemagicEnabled, isTrue);
      verifyNever(logger.warn(any));
    });

    test('should read each argument exactly once', () {
      configureArgumentValues(Stub.defaultValues);

      sut.readGeneratorArguments();

      // Verify arguments that supports interactive input are read exactly once
      final interactiveArguments = CreateCommandArguments.values
          .where((arg) => arg.supportsInteractiveInput);

      for (final argument in interactiveArguments) {
        verify(reader.read<Object>(
          argument,
          validation: anyNamed('validation'),
        )).called(1);
      }

      verifyNever(reader.read<Object>(
        CreateCommandArguments.interactive,
        validation: anyNamed('validation'),
      ));
    });
  });
}

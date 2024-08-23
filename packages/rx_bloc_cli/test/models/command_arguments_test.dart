import 'package:rx_bloc_cli/src/models/ci_cd_type.dart';
import 'package:rx_bloc_cli/src/models/command_arguments/create_command_arguments.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';
import 'package:test/test.dart';

import '../stub.dart';

void main() {
  List<CreateCommandArguments> optionalCommandArguments() {
    final mandatoryArguments = {
      CreateCommandArguments.projectName,
    };
    return CreateCommandArguments.values
        .where((argument) => !mandatoryArguments.contains(argument))
        .toList();
  }

  List<CreateCommandArguments> interactiveCommandArguments() {
    final nonInteractiveArguments = {
      CreateCommandArguments.interactive,
    };
    return CreateCommandArguments.values
        .where((argument) => !nonInteractiveArguments.contains(argument))
        .toList();
  }

  List<CreateCommandArguments> booleanCommandArguments() {
    return CreateCommandArguments.values
        .where((argument) => argument.type == CreateCommandArgumentType.boolean)
        .toList();
  }

  group('test command_arguments', () {
    test('should have the correct argument type', () {
      expect(CreateCommandArguments.projectName.type,
          equals(CreateCommandArgumentType.string));
      expect(CreateCommandArguments.organisation.type,
          equals(CreateCommandArgumentType.string));
      expect(CreateCommandArguments.analytics.type,
          equals(CreateCommandArgumentType.boolean));
      expect(CreateCommandArguments.changeLanguage.type,
          equals(CreateCommandArgumentType.boolean));
      expect(CreateCommandArguments.counter.type,
          equals(CreateCommandArgumentType.boolean));
      expect(CreateCommandArguments.deepLink.type,
          equals(CreateCommandArgumentType.boolean));
      expect(CreateCommandArguments.devMenu.type,
          equals(CreateCommandArgumentType.boolean));
      expect(CreateCommandArguments.login.type,
          equals(CreateCommandArgumentType.boolean));
      expect(CreateCommandArguments.otp.type,
          equals(CreateCommandArgumentType.boolean));
      expect(CreateCommandArguments.pinCode.type,
          equals(CreateCommandArgumentType.boolean));
      expect(CreateCommandArguments.patrol.type,
          equals(CreateCommandArgumentType.boolean));
      expect(CreateCommandArguments.realtimeCommunication.type,
          equals(CreateCommandArgumentType.realTimeCommunicationEnum));
      expect(CreateCommandArguments.cicd.type,
          equals(CreateCommandArgumentType.cicdTypeEnum));
      expect(CreateCommandArguments.socialLogins.type,
          equals(CreateCommandArgumentType.boolean));
      expect(CreateCommandArguments.widgetToolkit.type,
          equals(CreateCommandArgumentType.boolean));
      expect(CreateCommandArguments.interactive.type,
          equals(CreateCommandArgumentType.boolean));
    });

    test('should have the correct default value type', () {
      for (final argument in CreateCommandArguments.values) {
        if (!argument.mandatory) {
          expect(argument.hasMatchingTypeAndDefault, isTrue);
        }
      }
    });

    test('should have the correct default value', () {
      expect(() => CreateCommandArguments.projectName.defaultValue(),
          throwsUnsupportedError);
      expect(CreateCommandArguments.organisation.defaultValue(),
          equals(Stub.defaultOrganisation));
      expect(CreateCommandArguments.analytics.defaultValue(), isFalse);
      expect(CreateCommandArguments.changeLanguage.defaultValue(), isTrue);
      expect(CreateCommandArguments.counter.defaultValue(), isFalse);
      expect(CreateCommandArguments.deepLink.defaultValue(), isFalse);
      expect(CreateCommandArguments.devMenu.defaultValue(), isFalse);
      expect(CreateCommandArguments.login.defaultValue(), isTrue);
      expect(CreateCommandArguments.otp.defaultValue(), isFalse);
      expect(CreateCommandArguments.pinCode.defaultValue(), isFalse);
      expect(CreateCommandArguments.patrol.defaultValue(), isFalse);
      expect(CreateCommandArguments.realtimeCommunication.defaultValue(),
          equals(RealtimeCommunicationType.none));
      expect(CreateCommandArguments.cicd.defaultValue(),
          equals(CICDType.fastlane));
      expect(CreateCommandArguments.socialLogins.defaultValue(), isFalse);
      expect(CreateCommandArguments.widgetToolkit.defaultValue(), isFalse);
      expect(CreateCommandArguments.interactive.defaultValue(), isTrue);
    });

    test('should only cast default value to correct type', () {
      expect(() => CreateCommandArguments.interactive.defaultValue<bool>(),
          returnsNormally);
      expect(() => CreateCommandArguments.interactive.defaultValue<String>(),
          throwsA(isA<TypeError>()));
    });

    test('should have correct mandatory status', () {
      final arguments = optionalCommandArguments();
      expect(arguments.every((arg) => !arg.mandatory), isTrue);
    });

    test('should have default value if optional', () {
      final arguments = optionalCommandArguments();
      expect(arguments.every((arg) => arg.defaultsTo != null), isTrue);
    });

    test('should have correct interactive status', () {
      final arguments = interactiveCommandArguments();
      expect(arguments.every((arg) => arg.supportsInteractiveInput), isTrue);
    });

    test('should have prompt if interactive', () {
      final arguments = interactiveCommandArguments();
      expect(arguments.every((arg) => arg.hasValidPromptMessage), isTrue);
    });

    test('should have help message', () {
      final arguments = CreateCommandArguments.values;
      expect(arguments.every((arg) => arg.hasValidHelpMessage), isTrue);
    });

    test('should have default value if bool', () {
      final arguments = booleanCommandArguments();
      expect(() => arguments.every((arg) => arg.defaultValue<bool>()),
          returnsNormally);
    });
  });

  group('test argument_type enum', () {
    test('should have correct allowed values', () {
      final allowedRealtimeCommunication =
          RealtimeCommunicationType.supportedOptions.map((e) => e.name);
      final allowedCICDs = CICDType.supportedOptions.map((e) => e.name);

      expect(CreateCommandArgumentType.string.allowed, isNull);
      expect(CreateCommandArgumentType.boolean.allowed, isNull);
      expect(
          CreateCommandArgumentType.cicdTypeEnum.allowed, equals(allowedCICDs));
    });
  });
}

extension _MatchType on CreateCommandArgumentType {
  bool matches(Object? value) {
    if (value == null) {
      return false;
    }
    switch (this) {
      case CreateCommandArgumentType.string:
        return value is String;
      case CreateCommandArgumentType.boolean:
        return value is bool;
      case CreateCommandArgumentType.realTimeCommunicationEnum:
        return value is RealtimeCommunicationType;
      case CreateCommandArgumentType.cicdTypeEnum:
        return value is CICDType;
    }
  }
}

extension _MatchTypeDefault on CreateCommandArguments {
  bool get hasMatchingTypeAndDefault => type.matches(defaultsTo);

  bool get hasValidHelpMessage => (help != null && help!.isNotEmpty);

  bool get hasValidPromptMessage => (prompt != null && prompt!.isNotEmpty);
}

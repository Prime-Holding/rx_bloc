import 'package:rx_bloc_cli/src/models/command_arguments.dart';
import 'package:rx_bloc_cli/src/models/realtime_communication_type.dart';
import 'package:test/test.dart';

import '../stub.dart';

void main() {
  List<CommandArguments> optionalCommandArguments() {
    final mandatoryArguments = {
      CommandArguments.projectName,
    };
    return CommandArguments.values
        .where((argument) => !mandatoryArguments.contains(argument))
        .toList();
  }

  List<CommandArguments> interactiveCommandArguments() {
    final nonInteractiveArguments = {
      CommandArguments.interactive,
    };
    return CommandArguments.values
        .where((argument) => !nonInteractiveArguments.contains(argument))
        .toList();
  }

  List<CommandArguments> booleanCommandArguments() {
    return CommandArguments.values
        .where((argument) => argument.type == ArgumentType.boolean)
        .toList();
  }

  group('test command_arguments', () {
    test('should have the correct argument type', () {
      expect(CommandArguments.projectName.type, equals(ArgumentType.string));
      expect(CommandArguments.organisation.type, equals(ArgumentType.string));
      expect(CommandArguments.analytics.type, equals(ArgumentType.boolean));
      expect(
          CommandArguments.changeLanguage.type, equals(ArgumentType.boolean));
      expect(CommandArguments.counter.type, equals(ArgumentType.boolean));
      expect(CommandArguments.deepLink.type, equals(ArgumentType.boolean));
      expect(CommandArguments.devMenu.type, equals(ArgumentType.boolean));
      expect(CommandArguments.login.type, equals(ArgumentType.boolean));
      expect(CommandArguments.otp.type, equals(ArgumentType.boolean));
      expect(CommandArguments.pinCode.type, equals(ArgumentType.boolean));
      expect(CommandArguments.patrol.type, equals(ArgumentType.boolean));
      expect(CommandArguments.realtimeCommunication.type,
          equals(ArgumentType.realTimeCommunicationEnum));
      expect(CommandArguments.socialLogins.type, equals(ArgumentType.boolean));
      expect(CommandArguments.widgetToolkit.type, equals(ArgumentType.boolean));
      expect(CommandArguments.interactive.type, equals(ArgumentType.boolean));
    });

    test('should have the correct default value type', () {
      for (final argument in CommandArguments.values) {
        if (!argument.mandatory) {
          expect(argument.hasMatchingTypeAndDefault, isTrue);
        }
      }
    });

    test('should have the correct default value', () {
      expect(() => CommandArguments.projectName.defaultValue(),
          throwsUnsupportedError);
      expect(CommandArguments.organisation.defaultValue(),
          equals(Stub.defaultOrganisation));
      expect(CommandArguments.analytics.defaultValue(), isFalse);
      expect(CommandArguments.changeLanguage.defaultValue(), isTrue);
      expect(CommandArguments.counter.defaultValue(), isFalse);
      expect(CommandArguments.deepLink.defaultValue(), isFalse);
      expect(CommandArguments.devMenu.defaultValue(), isFalse);
      expect(CommandArguments.login.defaultValue(), isTrue);
      expect(CommandArguments.otp.defaultValue(), isFalse);
      expect(CommandArguments.pinCode.defaultValue(), isFalse);
      expect(CommandArguments.patrol.defaultValue(), isFalse);
      expect(CommandArguments.realtimeCommunication.defaultValue(),
          equals(RealtimeCommunicationType.none));
      expect(CommandArguments.socialLogins.defaultValue(), isFalse);
      expect(CommandArguments.widgetToolkit.defaultValue(), isFalse);
      expect(CommandArguments.interactive.defaultValue(), isTrue);
    });

    test('should only cast default value to correct type', () {
      expect(() => CommandArguments.interactive.defaultValue<bool>(),
          returnsNormally);
      expect(() => CommandArguments.interactive.defaultValue<String>(),
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
      final arguments = CommandArguments.values;
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

      expect(ArgumentType.string.allowed, isNull);
      expect(ArgumentType.boolean.allowed, isNull);
      expect(ArgumentType.realTimeCommunicationEnum.allowed,
          equals(allowedRealtimeCommunication));
    });
  });
}

extension _MatchType on ArgumentType {
  bool matches(Object? value) {
    if (value == null) {
      return false;
    }
    switch (this) {
      case ArgumentType.string:
        return value is String;
      case ArgumentType.boolean:
        return value is bool;
      case ArgumentType.realTimeCommunicationEnum:
        return value is RealtimeCommunicationType;
    }
  }
}

extension _MatchTypeDefault on CommandArguments {
  bool get hasMatchingTypeAndDefault => type.matches(defaultsTo);

  bool get hasValidHelpMessage => (help != null && help!.isNotEmpty);

  bool get hasValidPromptMessage => (prompt != null && prompt!.isNotEmpty);
}

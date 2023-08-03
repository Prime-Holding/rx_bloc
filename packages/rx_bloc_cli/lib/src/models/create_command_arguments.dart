part of '../commands/create_command.dart';

/// The command arguments that the RxBlocCli package supports
enum _CommandArgument {
  projectName(
    name: 'project-name',
    type: _ArgumentType.string,
    help: 'The project name for this new Flutter project. This must be a '
        'valid dart package name. If no project name is supplied, '
        'the name of the directory is used as the project name.',
    mandatory: true,
  ),
  organisation(
    name: 'organisation',
    type: _ArgumentType.string,
    help: 'The organisation name.',
  ),
  analytics(
    name: 'enable-analytics',
    type: _ArgumentType.boolean,
    help: 'Enables Firebase analytics for the project',
  ),
  changeLanguage(
    name: 'enable-change-language',
    type: _ArgumentType.boolean,
    help: 'Enables change language',
  ),
  counter(
    name: 'enable-feature-counter',
    type: _ArgumentType.boolean,
    help: 'The counter showcase feature',
  ),
  deepLink(
    name: 'enable-feature-deeplinks',
    type: _ArgumentType.boolean,
    help: 'The deeplink showcase feature',
  ),
  devMenu(
    name: 'enable-dev-menu',
    type: _ArgumentType.boolean,
    help: 'Enables Dev Menu for the project',
  ),
  login(
    name: 'enable-login',
    type: _ArgumentType.boolean,
    help: 'Enables login feature for the project',
  ),
  otp(
    name: 'enable-otp',
    type: _ArgumentType.boolean,
    help: 'Enables OTP feature for the project',
  ),
  patrol(
    name: 'enable-patrol',
    type: _ArgumentType.boolean,
    help: 'Enables Patrol integration tests for the project',
  ),
  realtimeCommunication(
    name: 'realtime-communication',
    type: _ArgumentType.realTimeCommunicationEnum,
    help: 'Enables realtime communication facilities like SSE, WebSocket '
        'or gRPC',
  ),
  socialLogins(
    name: 'enable-social-logins',
    type: _ArgumentType.boolean,
    help: 'Enables social login with Apple, Facebook and Google for the '
        'project',
  ),
  widgetToolkit(
    name: 'enable-feature-widget-toolkit',
    type: _ArgumentType.boolean,
    help: 'The widget toolkit showcase feature',
  ),
  interactive(
    name: 'interactive',
    type: _ArgumentType.boolean,
    help: 'Allows to select the included features interactively',
  );

  const _CommandArgument({
    required this.name,
    required this.type,
    this.help,
    this.mandatory = false,
  });

  final String name;
  final _ArgumentType type;
  final String? help;
  final bool mandatory;
}

/// Specifies all types supported by _CommandArgument
/// and enforces non-interactive value restrictions
enum _ArgumentType {
  string,
  boolean,
  realTimeCommunicationEnum;

  /// Allowed values for each type
  Iterable<String>? get allowed => switch (this) {
        _ArgumentType.string => null,
        _ArgumentType.boolean => [true, false].map((e) => e.toString()),
        _ArgumentType.realTimeCommunicationEnum =>
          _RealtimeCommunicationType.values.map((e) => e.toString()),
      };

  /// Checks if the type corresponds to the provided value's type
  bool matches(Object value) => switch (this) {
        _ArgumentType.string => value is String,
        _ArgumentType.boolean => value is bool,
        _ArgumentType.realTimeCommunicationEnum =>
          value is _RealtimeCommunicationType,
      };
}

/// Default values for each _CommandArgument
/// Used as fallback values for project generation
extension _NonInteractiveDefault on _CommandArgument {
  Object get defaultValue => _withCheck(switch (this) {
        _CommandArgument.projectName => '',
        _CommandArgument.organisation => 'com.example',
        _CommandArgument.analytics => false,
        _CommandArgument.changeLanguage => true,
        _CommandArgument.counter => false,
        _CommandArgument.deepLink => false,
        _CommandArgument.devMenu => false,
        _CommandArgument.login => true,
        _CommandArgument.otp => false,
        _CommandArgument.patrol => false,
        _CommandArgument.realtimeCommunication =>
          _RealtimeCommunicationType.none,
        _CommandArgument.socialLogins => false,
        _CommandArgument.widgetToolkit => false,
        _CommandArgument.interactive => true,
      });

  /// Verifies:
  /// - no default value is provided for mandatory arguments
  /// - the provided value type matches the expected type
  Object _withCheck(Object value) {
    // Mandatory arguments should not have default value
    assert(!mandatory, 'You should not require default value for $name');
    assert(type.matches(value), 'The provided value does not match $type');

    return value;
  }
}

extension _PromptTextProvider on _CommandArgument {
  String? get prompt => switch (this) {
        _CommandArgument.projectName => 'Project name:',
        _CommandArgument.organisation => 'Organization name:',
        _CommandArgument.analytics => 'Enable analytics:',
        _CommandArgument.changeLanguage => 'Enable change language:',
        _CommandArgument.counter => 'Enable counter showcase:',
        _CommandArgument.deepLink => 'Enable deeplink:',
        _CommandArgument.devMenu => 'Enable dev menu:',
        _CommandArgument.login => 'Enable login:',
        _CommandArgument.otp => 'Enable OTP authentication:',
        _CommandArgument.patrol => 'Enable Patrol integration tests:',
        _CommandArgument.realtimeCommunication =>
          'Select realtime communication type [ ${_RealtimeCommunicationType.options} ]:',
        _CommandArgument.socialLogins => 'Enable social logins:',
        _CommandArgument.widgetToolkit => 'Enable widget toolkit showcase:',
        _CommandArgument.interactive => null,
      };
}

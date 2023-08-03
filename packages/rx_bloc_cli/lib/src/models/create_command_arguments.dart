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

  Iterable<String>? get allowed => switch (this) {
        _ArgumentType.string => null,
        _ArgumentType.boolean => [true, false].map((e) => e.toString()),
        _ArgumentType.realTimeCommunicationEnum =>
          _RealtimeCommunicationType.values.map((e) => e.toString()),
      };
}

/// Default values for each _CommandArgument
/// Used as fallback values for project generation
extension _NonInteractiveDefault on _CommandArgument {
  Object get defaultValue => switch (this) {
        _CommandArgument.projectName => _checked(''),
        _CommandArgument.organisation => _checked('com.example'),
        _CommandArgument.analytics => _checked(false),
        _CommandArgument.changeLanguage => _checked(true),
        _CommandArgument.counter => _checked(false),
        _CommandArgument.deepLink => _checked(false),
        _CommandArgument.devMenu => _checked(false),
        _CommandArgument.login => _checked(true),
        _CommandArgument.otp => _checked(false),
        _CommandArgument.patrol => _checked(false),
        _CommandArgument.realtimeCommunication =>
          _checked(_RealtimeCommunicationType.none),
        _CommandArgument.socialLogins => _checked(false),
        _CommandArgument.widgetToolkit => _checked(false),
        _CommandArgument.interactive => _checked(false),
      };

  Object _checked(Object value) {
    // Mandatory arguments should not have default value
    assert(!mandatory, 'You should not require default value for $name');

    // The _CommandArgument type should match the provided value type
    switch (type) {
      case _ArgumentType.string:
        assert(value is String, '');
      case _ArgumentType.boolean:
        assert(value is bool, '');
      case _ArgumentType.realTimeCommunicationEnum:
        assert(value is _RealtimeCommunicationType, '');
    }

    return value;
  }
}

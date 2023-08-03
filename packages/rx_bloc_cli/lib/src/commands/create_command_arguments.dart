part of 'create_command.dart';

enum _Argument {
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
  );

  const _Argument({
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

extension _NonInteractiveDefault on _Argument {
  String? get nonInteractiveDefault => switch (this) {
        _Argument.projectName => null,
        _Argument.organisation => 'com.example',
        _Argument.analytics => false.toString(),
        _Argument.changeLanguage => true.toString(),
        _Argument.counter => false.toString(),
        _Argument.deepLink => false.toString(),
        _Argument.devMenu => false.toString(),
        _Argument.login => true.toString(),
        _Argument.otp => false.toString(),
        _Argument.patrol => false.toString(),
        _Argument.realtimeCommunication => _RealtimeCommunicationType.none.name,
        _Argument.socialLogins => false.toString(),
        _Argument.widgetToolkit => false.toString(),
      };
}

extension _ArgumentHandler on ArgParser {
  void addArguments(List<_Argument> arguments) {
    for (final arg in arguments) {
      addOption(
        arg.name,
        help: arg.help,
        allowed: arg.type.allowed,
        mandatory: arg.mandatory,
      );
    }
  }
}

enum _ArgumentType {
  string,
  boolean,
  realTimeCommunicationEnum;

  Iterable<String>? get allowed => switch (this) {
        _ArgumentType.string => null,
        _ArgumentType.boolean => [true, false].map(
            (e) => e.toString(),
          ),
        _ArgumentType.realTimeCommunicationEnum =>
          _RealtimeCommunicationType.values.map(
            (e) => e.name,
          ),
      };
}
/*
_Argument.projectName
_Argument.organisation
_Argument.analytics
_Argument.changeLanguage
_Argument.counter
_Argument.deepLink
_Argument.devMenu
_Argument.login
_Argument.otp
_Argument.patrol
_Argument.realtimeCommunication
_Argument.socialLogins
_Argument.widgetToolkit
*/

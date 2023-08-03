part of 'create_command.dart';

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

extension _NonInteractiveDefault on _CommandArgument {
  String get nonInteractiveDefault => switch (this) {
        _CommandArgument.projectName => throw UnsupportedError(
            'You should not require default value for $name'),
        _CommandArgument.organisation => 'com.example',
        _CommandArgument.analytics => false.toString(),
        _CommandArgument.changeLanguage => true.toString(),
        _CommandArgument.counter => false.toString(),
        _CommandArgument.deepLink => false.toString(),
        _CommandArgument.devMenu => false.toString(),
        _CommandArgument.login => true.toString(),
        _CommandArgument.otp => false.toString(),
        _CommandArgument.patrol => false.toString(),
        _CommandArgument.realtimeCommunication =>
          _RealtimeCommunicationType.none.name,
        _CommandArgument.socialLogins => false.toString(),
        _CommandArgument.widgetToolkit => false.toString(),
      };
}

extension _ArgumentHandler on ArgParser {
  void addArguments(List<_CommandArgument> arguments) {
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

extension _ReadArgument on ArgResults {
  String readOrDefault(_CommandArgument arg) =>
      _cast(this[arg.name]) ?? arg.nonInteractiveDefault;

  T? _cast<T>(x) => x is T ? x : null;
}

class _CreateCommandArguments {
  _CreateCommandArguments({
    required this.projectName,
    required this.organisation,
    required this.enableAnalytics,
    required this.outputDirectory,
    required this.enableCounterFeature,
    required this.enableDeeplinkFeature,
    required this.enableWidgetToolkitFeature,
    required this.enableLogin,
    required this.enableSocialLogins,
    required this.enableChangeLanguage,
    required this.enableDevMenu,
    required this.enableOtpFeature,
    required this.enablePatrolTests,
    required this.realtimeCommunicationType,
  });

  final String projectName;
  final String organisation;
  final Directory outputDirectory;

  final bool enableAnalytics;
  final bool enableChangeLanguage;
  final bool enableCounterFeature;
  final bool enableDeeplinkFeature;
  final bool enableDevMenu;
  final bool enableLogin;
  final bool enableOtpFeature;
  final bool enablePatrolTests;
  final bool enableSocialLogins;
  final bool enableWidgetToolkitFeature;

  final _RealtimeCommunicationType realtimeCommunicationType;

  bool get hasAuthentication =>
      enableLogin || enableSocialLogins || enableOtpFeature;

  // Whether Firebase is used in the generated project.
  // Usually `true` because Firebase is used for push notifications.
  bool get usesFirebase => enableAnalytics || true;

  bool get usesPushNotifications => true;

  bool get realtimeCommunicationEnabled =>
      realtimeCommunicationType != _RealtimeCommunicationType.none;

  String get organisationName =>
      organisation.substring(organisation.indexOf('.') + 1);

  String get organisationDomain =>
      organisation.substring(0, organisation.indexOf('.'));
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

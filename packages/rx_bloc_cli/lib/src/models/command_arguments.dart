import 'realtime_communication_type.dart';

/// The command arguments that the RxBlocCli package supports
enum CommandArguments {
  /// Project name
  projectName(
    name: 'project-name',
    type: ArgumentType.string,
    help: 'The project name for this new Flutter project. This must be a '
        'valid dart package name. If no project name is supplied, '
        'the name of the directory is used as the project name.',
    mandatory: true,
  ),

  /// Organisation name
  organisation(
    name: 'organisation',
    type: ArgumentType.string,
    help: 'The organisation name.',
  ),

  /// Analytics
  analytics(
    name: 'enable-analytics',
    type: ArgumentType.boolean,
    help: 'Enables Firebase analytics for the project',
  ),

  /// Change language
  changeLanguage(
    name: 'enable-change-language',
    type: ArgumentType.boolean,
    help: 'Enables change language',
  ),

  /// Counter showcase
  counter(
    name: 'enable-feature-counter',
    type: ArgumentType.boolean,
    help: 'The counter showcase feature',
  ),

  /// Deep links
  deepLink(
    name: 'enable-feature-deeplinks',
    type: ArgumentType.boolean,
    help: 'The deeplink showcase feature',
  ),

  /// Dev menu
  devMenu(
    name: 'enable-dev-menu',
    type: ArgumentType.boolean,
    help: 'Enables Dev Menu for the project',
  ),

  /// Login
  login(
    name: 'enable-login',
    type: ArgumentType.boolean,
    help: 'Enables login feature for the project',
  ),

  /// OTP authentication
  otp(
    name: 'enable-otp',
    type: ArgumentType.boolean,
    help: 'Enables OTP feature for the project',
  ),

  /// Patrol
  patrol(
    name: 'enable-patrol',
    type: ArgumentType.boolean,
    help: 'Enables Patrol integration tests for the project',
  ),

  /// Real-time communication
  realtimeCommunication(
    name: 'realtime-communication',
    type: ArgumentType.realTimeCommunicationEnum,
    help: 'Enables realtime communication facilities like SSE, WebSocket '
        'or gRPC',
  ),

  /// Social logins
  socialLogins(
    name: 'enable-social-logins',
    type: ArgumentType.boolean,
    help: 'Enables social login with Apple, Facebook and Google for the '
        'project',
  ),

  /// Widget toolkit showcase
  widgetToolkit(
    name: 'enable-feature-widget-toolkit',
    type: ArgumentType.boolean,
    help: 'The widget toolkit showcase feature',
  ),

  /// Interactive input
  interactive(
    name: 'interactive',
    type: ArgumentType.boolean,
    help: 'Allows to select the included features interactively',
  );

  const CommandArguments({
    required this.name,
    required this.type,
    this.help,
    this.mandatory = false,
  });

  /// The command argument name
  final String name;

  /// The command argument type
  final ArgumentType type;

  /// The command argument help information
  final String? help;

  /// The command argument marked as mandatory or optional
  final bool mandatory;
}

/// Types supported by CommandArguments. Used to enforce input restrictions.
enum ArgumentType {
  /// String type
  string,

  /// Boolean type. Accepts 'true' and 'false'
  boolean,

  /// Custom type: RealtimeCommunicationEnum
  realTimeCommunicationEnum;

  /// Allowed values for each supported type
  Iterable<String>? get allowed => switch (this) {
        ArgumentType.string => null,
        ArgumentType.boolean => [true, false].map((e) => e.toString()),
        ArgumentType.realTimeCommunicationEnum =>
          RealtimeCommunicationType.values.map((e) => e.toString()),
      };

  /// Checks if the provided Object value is of the expected type
  bool matchesTypeOf(Object value) => switch (this) {
        ArgumentType.string => value is String,
        ArgumentType.boolean => value is bool,
        ArgumentType.realTimeCommunicationEnum =>
          value is RealtimeCommunicationType,
      };
}

/// Placeholder value. Can be used for mandatory arguments default.
final _placeholder = Object();

/// Default values for each _CommandArgument
/// Used as fallback values for project generation
extension NonInteractiveDefault on CommandArguments {
  /// Default value for CommandArgument.
  /// Throws if CommandArgument is mandatory or types mismatch
  Object get defaultValue => _withCheck(switch (this) {
        CommandArguments.projectName => _placeholder,
        CommandArguments.organisation => 'com.example',
        CommandArguments.analytics => false,
        CommandArguments.changeLanguage => true,
        CommandArguments.counter => false,
        CommandArguments.deepLink => false,
        CommandArguments.devMenu => false,
        CommandArguments.login => true,
        CommandArguments.otp => false,
        CommandArguments.patrol => false,
        CommandArguments.realtimeCommunication =>
          RealtimeCommunicationType.none,
        CommandArguments.socialLogins => false,
        CommandArguments.widgetToolkit => false,
        CommandArguments.interactive => true,
      });

  /// Verifies:
  /// - no default value is provided for mandatory arguments
  /// - the provided value type matches the expected type
  Object _withCheck(Object value) {
    assert(!mandatory, 'You should not require a default value for $name');
    assert(type.matchesTypeOf(value), 'Type mismatch for $value and $type');
    return value;
  }
}

/// Interactive prompts for user input
extension PromptTextProvider on CommandArguments {
  /// Text displayed when selecting features interactively
  String? get prompt => switch (this) {
        CommandArguments.projectName => 'Project name:',
        CommandArguments.organisation => 'Organization name:',
        CommandArguments.analytics => 'Enable analytics:',
        CommandArguments.changeLanguage => 'Enable change language:',
        CommandArguments.counter => 'Enable counter showcase:',
        CommandArguments.deepLink => 'Enable deeplink:',
        CommandArguments.devMenu => 'Enable dev menu:',
        CommandArguments.login => 'Enable login:',
        CommandArguments.otp => 'Enable OTP authentication:',
        CommandArguments.patrol => 'Enable Patrol integration tests:',
        CommandArguments.realtimeCommunication =>
          'Select realtime communication type [ ${_rtcSupportedOptions()} ]:',
        CommandArguments.socialLogins => 'Enable social logins:',
        CommandArguments.widgetToolkit => 'Enable widget toolkit showcase:',
        CommandArguments.interactive => null,
      };
}

/// Utility method for converting RealtimeCommunicationType options to prompt
String _rtcSupportedOptions() =>
    RealtimeCommunicationType.supported.map((e) => e.toString()).join(' | ');

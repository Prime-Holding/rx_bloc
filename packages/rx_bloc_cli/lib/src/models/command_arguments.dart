import 'package:rx_bloc_cli/src/models/ci_cd_type.dart';

import 'realtime_communication_type.dart';

/// The command arguments that the RxBlocCli package supports
enum CommandArguments {
  /// Project name
  projectName(
    name: 'project-name',
    type: ArgumentType.string,
    defaultsTo: null,
    prompt: 'Project name:',
    help: 'The project name for this new Flutter project. This must be a '
        'valid dart package name. If no project name is supplied, '
        'the name of the directory is used as the project name.',
  ),

  /// Organisation name
  organisation(
    name: 'organisation',
    type: ArgumentType.string,
    defaultsTo: 'com.example',
    prompt: 'Organization name:',
    help: 'The organisation name.',
  ),

  /// Analytics
  analytics(
    name: 'enable-analytics',
    type: ArgumentType.boolean,
    defaultsTo: false,
    prompt: 'Enable analytics:',
    help: 'Enables Firebase Analytics and Crashlytics for the project',
  ),

  /// Change language
  changeLanguage(
    name: 'enable-change-language',
    type: ArgumentType.boolean,
    defaultsTo: true,
    prompt: 'Enable change language:',
    help: 'Enables change language',
  ),

  /// Counter showcase
  counter(
    name: 'enable-feature-counter',
    type: ArgumentType.boolean,
    defaultsTo: false,
    prompt: 'Enable counter showcase:',
    help: 'The counter showcase feature',
  ),

  /// Deep links
  deepLink(
    name: 'enable-feature-deeplinks',
    type: ArgumentType.boolean,
    defaultsTo: false,
    prompt: 'Enable deeplink:',
    help: 'The deeplink showcase feature',
  ),

  /// Dev menu
  devMenu(
    name: 'enable-dev-menu',
    type: ArgumentType.boolean,
    defaultsTo: false,
    prompt: 'Enable dev menu:',
    help: 'Enables Dev Menu for the project',
  ),

  /// Login
  login(
    name: 'enable-login',
    type: ArgumentType.boolean,
    defaultsTo: true,
    prompt: 'Enable login:',
    help: 'Enables login feature for the project',
  ),

  /// OTP authentication
  otp(
    name: 'enable-otp',
    type: ArgumentType.boolean,
    defaultsTo: false,
    prompt: 'Enable OTP authentication:',
    help: 'Enables OTP feature for the project',
  ),

  /// Pin Code authentication
  pinCode(
    name: 'enable-pin-code',
    type: ArgumentType.boolean,
    defaultsTo: false,
    prompt: 'Enable Pin Code authentication:',
    help: 'Enables Pin Code feature for the project',
  ),

  /// Patrol
  patrol(
    name: 'enable-patrol',
    type: ArgumentType.boolean,
    defaultsTo: false,
    prompt: 'Enable Patrol integration tests:',
    help: 'Enables Patrol integration tests for the project',
  ),

  /// Real-time communication
  realtimeCommunication(
    name: 'realtime-communication',
    type: ArgumentType.realTimeCommunicationEnum,
    defaultsTo: RealtimeCommunicationType.none,
    prompt: 'Select realtime communication type:',
    help: 'Enables realtime communication facilities like SSE, WebSocket '
        'or gRPC',
  ),

  /// CI/CD
  cicd(
    name: 'cicd',
    type: ArgumentType.cicdTypeEnum,
    defaultsTo: CICDType.fastlane,
    prompt: 'Select ci/cd type:',
    help: 'Provides a template for setting up ci/cd for your project',
  ),

  /// Social logins
  socialLogins(
    name: 'enable-social-logins',
    type: ArgumentType.boolean,
    defaultsTo: false,
    prompt: 'Enable social logins:',
    help: 'Enables social login with Apple, Facebook and Google for the '
        'project',
  ),

  /// Widget toolkit showcase
  widgetToolkit(
    name: 'enable-feature-widget-toolkit',
    type: ArgumentType.boolean,
    defaultsTo: false,
    prompt: 'Enable widget toolkit showcase:',
    help: 'The widget toolkit showcase feature',
  ),

  /// Auth Matrix
  authMatrix(
    name: 'enable-auth-matrix',
    type: ArgumentType.boolean,
    defaultsTo: false,
    prompt: 'Enabled auth matrix:',
    help: 'Enables auth matrix feature for the project',
  ),

  /// Interactive input
  interactive(
    name: 'interactive',
    type: ArgumentType.boolean,
    defaultsTo: true,
    help: 'Allows to select the included features interactively',
  );

  const CommandArguments({
    required this.name,
    required this.type,
    required this.defaultsTo,
    this.prompt,
    this.help,
  });

  /// The command argument name
  final String name;

  /// The command argument type
  final ArgumentType type;

  /// The command argument help information
  final String? help;

  /// Default value for the argument
  final Object? defaultsTo;

  /// Interactive prompt
  final String? prompt;

  /// Indicates whether the command is supposed to be read interactively
  bool get supportsInteractiveInput => prompt != null;

  /// Indicates whether the argument is mandatory or can be defaulted
  bool get mandatory => defaultsTo == null;

  /// Returns the default value for the argument cast to a specific type
  /// Throws if no default value is present or type is mismatched
  T defaultValue<T extends Object>() {
    final value = defaultsTo;
    if (value == null) {
      throw UnsupportedError('$name is mandatory.');
    }
    if (value is! T) {
      throw TypeError();
    }
    return value;
  }
}

/// Types supported by CommandArguments. Used to enforce input restrictions.
enum ArgumentType {
  /// String type
  string,

  /// Boolean type. Accepts 'true' and 'false'
  boolean,

  /// Custom type: RealtimeCommunicationEnum
  realTimeCommunicationEnum,

  /// Custom type: cicdTypeEnum
  cicdTypeEnum;

  /// Allowed values for each supported type
  Iterable<String>? get allowed => switch (this) {
        ArgumentType.string => null,
        ArgumentType.boolean => null,
        ArgumentType.realTimeCommunicationEnum =>
          RealtimeCommunicationType.supportedOptions.map((e) => e.toString()),
        ArgumentType.cicdTypeEnum =>
          CICDType.supportedOptions.map((e) => e.toString()),
      };
}

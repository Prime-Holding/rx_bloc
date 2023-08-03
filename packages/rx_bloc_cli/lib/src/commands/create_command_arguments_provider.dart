part of 'create_command.dart';

class _CreateCommandArgumentsProvider {
  _CreateCommandArgumentsProvider(this.arguments, this.command);

  final ArgResults arguments;
  final Command command;

  /// Regex for package name
  final RegExp _packageNameRegExp = RegExp('[a-z_][a-z0-9_]*');

  /// Regex for organization name and domain
  final RegExp _orgNameDomainRegExp =
      RegExp('^([A-Za-z]{2,6})(\\.(?!-)[A-Za-z0-9-]{1,63}(?<!-))+\$');

  /// endregion

  _CreateCommandArguments generate() {
    return _generateNonInteractive();
  }

  _CreateCommandArguments _generateNonInteractive() {
    return _CreateCommandArguments(
      projectName: _parseProjectName(arguments),
      organisation: _parseOrganisation(arguments),
      enableAnalytics: _parseEnableAnalytics(arguments),
      outputDirectory: _parseOutputDirectory(arguments),
      enableCounterFeature: _parseEnableCounter(arguments),
      enableDeeplinkFeature: _parseEnableDeeplinkFeature(arguments),
      enableWidgetToolkitFeature: _parseEnableWidgetToolkit(arguments),
      enableLogin: _parseEnableFeatureLogin(arguments),
      enableSocialLogins: _parseEnableSocialLogins(arguments),
      enableChangeLanguage: _parseEnableChangeLanguage(arguments),
      enableDevMenu: _parseEnableDevMenu(arguments),
      enableOtpFeature: _parseEnableOtpFeature(arguments),
      enablePatrolTests: _parseEnablePatrolTests(arguments),
      realtimeCommunicationType: _parseRealtimeCommunicationType(arguments),
    );
  }

  _CreateCommandArguments _generateInteractive() {
    throw UnimplementedError();
  }

  /// Gets the project name.
  String _parseProjectName(ArgResults arguments) {
    final projectName = arguments.readOrDefault(_CommandArgument.projectName);
    _validateProjectName(projectName);
    return projectName;
  }

  /// Returns the organization name with domain in front of it
  String _parseOrganisation(ArgResults arguments) {
    final value = arguments.readOrDefault(_CommandArgument.organisation);
    _validateOrganisation(value);
    return value;
  }

  /// Gets the directory used for the file generation
  Directory _parseOutputDirectory(ArgResults arguments) {
    final rest = arguments.rest;
    _validateOutputDirectoryArg(rest);
    return Directory(rest.first);
  }

  /// Returns whether the project will be created with counter feature
  bool _parseEnableCounter(ArgResults arguments) {
    final counterEnabled = arguments.readOrDefault(_CommandArgument.counter);
    return counterEnabled.toLowerCase() == 'true';
  }

  /// Return whether the project will be created with patrol integration tests
  bool _parseEnablePatrolTests(ArgResults arguments) {
    final patrolEnabled = arguments.readOrDefault(_CommandArgument.patrol);
    return patrolEnabled.toLowerCase() == 'true';
  }

  /// Returns whether the project will be created with widget toolkit feature
  bool _parseEnableWidgetToolkit(ArgResults arguments) {
    final widgetToolkitEnabled =
        arguments.readOrDefault(_CommandArgument.widgetToolkit);
    return widgetToolkitEnabled.toLowerCase() == 'true';
  }

  /// Returns whether the project will enable change language
  bool _parseEnableChangeLanguage(ArgResults arguments) {
    final changeLanguageEnabled =
        arguments.readOrDefault(_CommandArgument.changeLanguage);
    return changeLanguageEnabled.toLowerCase() == 'true';
  }

  /// Returns whether the project will use analytics or not
  bool _parseEnableAnalytics(ArgResults arguments) {
    final analyticsEnabled = arguments.readOrDefault(_CommandArgument.analytics);
    return analyticsEnabled.toLowerCase() == 'true';
  }

  /// Returns whether the project will be created with deeplink feature
  bool _parseEnableDeeplinkFeature(ArgResults arguments) {
    final deeplinkEnabled = arguments.readOrDefault(_CommandArgument.deepLink);
    return deeplinkEnabled.toLowerCase() == 'true';
  }

  /// Returns whether the project will be created with login feature
  bool _parseEnableFeatureLogin(ArgResults arguments) {
    final featureLoginEnabled = arguments.readOrDefault(_CommandArgument.login);
    return featureLoginEnabled.toLowerCase() == 'true';
  }

  /// Returns whether the project will be created with social logins feature
  bool _parseEnableSocialLogins(ArgResults arguments) {
    final socialLoginsEnabled = arguments.readOrDefault(_CommandArgument.socialLogins);
    return socialLoginsEnabled.toLowerCase() == 'true';
  }

  /// Returns whether the project will be created with dev menu lib
  bool _parseEnableDevMenu(ArgResults arguments) {
    final devMenuEnabled = arguments.readOrDefault(_CommandArgument.devMenu);
    return devMenuEnabled.toLowerCase() == 'true';
  }

  /// Returns whether the project will be created with otp feature
  bool _parseEnableOtpFeature(ArgResults arguments) {
    final otpFeatureEnabled = arguments.readOrDefault(_CommandArgument.otp);
    return otpFeatureEnabled.toLowerCase() == 'true';
  }

  _RealtimeCommunicationType _parseRealtimeCommunicationType(
      ArgResults arguments) {
    final type = arguments.readOrDefault(_CommandArgument.realtimeCommunication);

    try {
      return _RealtimeCommunicationType.values
          .firstWhere((e) => e.name == type);
    } catch (e) {
      throw UsageException(
        'Unexpected value for ${_CommandArgument.realtimeCommunication.name}.',
        command.usage,
      );
    }
  }

  /// endregion

  /// region Validation

  void _validateProjectName(String name) {
    final isValidProjectName = _stringMatchesRegex(_packageNameRegExp, name);
    if (!isValidProjectName) {
      throw UsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        command.usage,
      );
    }
  }

  void _validateOutputDirectoryArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the output directory.',
        command.usage,
      );
    }

    if (args.length > 1) {
      throw UsageException(
          'Multiple output directories specified.', command.usage);
    }
  }

  void _validateOrganisation(String orgName) {
    if (orgName.trim().isEmpty) {
      throw UsageException('No organisation name specified.', command.usage);
    }

    if (!_stringMatchesRegex(_orgNameDomainRegExp, orgName)) {
      throw UsageException('Invalid organisation name.', command.usage);
    }
  }

  bool _stringMatchesRegex(RegExp regex, String name) {
    final match = regex.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }

  /// endregion
}

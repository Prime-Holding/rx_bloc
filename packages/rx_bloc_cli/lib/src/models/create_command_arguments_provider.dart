part of '../commands/create_command.dart';

class _CreateCommandArgumentsValueProvider {
  _CreateCommandArgumentsValueProvider(
      this.arguments, this.command, this._logger);

  final ArgResults arguments;
  final Logger _logger;
  final Command command;

  /// Regex for package name
  final RegExp _packageNameRegExp = RegExp('[a-z_][a-z0-9_]*');

  /// Regex for organization name and domain
  final RegExp _orgNameDomainRegExp =
      RegExp('^([A-Za-z]{2,6})(\\.(?!-)[A-Za-z0-9-]{1,63}(?<!-))+\$');

  /// endregion

  _ProjectGenerationArguments generate() =>
      arguments.isInteractiveConfigurationEnabled
          ? _generateInteractive()
          : _generateNonInteractive();

  _ProjectGenerationArguments _generateNonInteractive() {
    return _ProjectGenerationArguments(
      projectName: _parseProjectName(
          arguments.stringOrDefault(_CommandArgument.projectName)),
      organisation: _parseOrganisation(
          arguments.stringOrDefault(_CommandArgument.organisation)),
      outputDirectory: _parseOutputDirectory(arguments),
      enableAnalytics: arguments.boolReadOrDefault(_CommandArgument.analytics),
      enableCounter: arguments.boolReadOrDefault(_CommandArgument.counter),
      enableDeeplink: arguments.boolReadOrDefault(_CommandArgument.deepLink),
      enableWidgetToolkit:
          arguments.boolReadOrDefault(_CommandArgument.widgetToolkit),
      enableLogin: arguments.boolReadOrDefault(_CommandArgument.login),
      enableSocialLogins:
          arguments.boolReadOrDefault(_CommandArgument.socialLogins),
      enableChangeLanguage:
          arguments.boolReadOrDefault(_CommandArgument.changeLanguage),
      enableDevMenu: arguments.boolReadOrDefault(_CommandArgument.devMenu),
      enableOtp: arguments.boolReadOrDefault(_CommandArgument.otp),
      enablePatrolTests: arguments.boolReadOrDefault(_CommandArgument.patrol),
      realtimeCommunication: _parse(arguments),
    );
  }

  _ProjectGenerationArguments _generateInteractive() {
    return _ProjectGenerationArguments(
      projectName: _parseProjectName(_readString(_CommandArgument.projectName)),
      organisation:
          _parseOrganisation(_readString(_CommandArgument.organisation)),
      outputDirectory: _parseOutputDirectory(arguments),
      enableAnalytics: _readBool(_CommandArgument.analytics),
      enableCounter: _readBool(_CommandArgument.counter),
      enableDeeplink: _readBool(_CommandArgument.deepLink),
      enableWidgetToolkit: _readBool(_CommandArgument.widgetToolkit),
      enableLogin: _readBool(_CommandArgument.login),
      enableSocialLogins: _readBool(_CommandArgument.socialLogins),
      enableChangeLanguage: _readBool(_CommandArgument.changeLanguage),
      enableDevMenu: _readBool(_CommandArgument.devMenu),
      enableOtp: _readBool(_CommandArgument.otp),
      enablePatrolTests: _readBool(_CommandArgument.patrol),
      realtimeCommunication: _readRealtimeCommunication(),
    );
  }

  /// Gets the project name.
  String _parseProjectName(String projectName) {
    _validateProjectName(projectName);
    return projectName;
  }

  /// Returns the organization name with domain in front of it
  String _parseOrganisation(String organisation) {
    _validateOrganisation(organisation);
    return organisation;
  }

  /// Gets the directory used for the file generation
  Directory _parseOutputDirectory(ArgResults arguments) {
    final rest = arguments.rest;
    _validateOutputDirectoryArg(rest);
    return Directory(rest.first);
  }

  _RealtimeCommunicationType _parse(ArgResults arguments) {
    try {
      return arguments.realTimeCommunicationType;
    } catch (e) {
      throw UsageException(
        'Unexpected value for ${_CommandArgument.realtimeCommunication.name}.',
        command.usage,
      );
    }
  }

  bool _readBool(_CommandArgument arg) {
    assert(arg.type == _ArgumentType.boolean);
    return _logger.confirm(arg.prompt, defaultValue: arg.defaultValue as bool);
  }

  String _readString(_CommandArgument arg) {
    assert(arg.type == _ArgumentType.string);
    return _logger.prompt(arg.prompt, defaultValue: arg.defaultValue);
  }

  _RealtimeCommunicationType _readRealtimeCommunication() {
    final arg = _CommandArgument.realtimeCommunication;
    final text = _logger.prompt(arg.prompt, defaultValue: arg.defaultValue);
    return _RealtimeCommunicationType.values
        .firstWhere((element) => element.name == text);
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

  /// endregion}
}

extension _PromptTextProvider on _CommandArgument {
  String get prompt => switch (this) {
        _CommandArgument.projectName => 'Project name',
        _CommandArgument.organisation => 'Organization name',
        _CommandArgument.analytics => 'Enable analytics',
        _CommandArgument.changeLanguage => 'Enable change language',
        _CommandArgument.counter => 'Enable counter showcase',
        _CommandArgument.deepLink => 'Enable deeplink',
        _CommandArgument.devMenu => 'Enable dev menu',
        _CommandArgument.login => 'Enable login',
        _CommandArgument.otp => 'Enable OTP authentication',
        _CommandArgument.patrol => 'Enable Patrol integration tests',
        _CommandArgument.realtimeCommunication =>
          'Select realtime communication type [${_OptionsProvider.options}]',
        _CommandArgument.socialLogins => 'Enable social logins',
        _CommandArgument.widgetToolkit => 'Enable widget toolkit showcase',
        _CommandArgument.interactive => throw UnsupportedError(
            'This option is not supported for interactive input'),
      };
}

extension _OptionsProvider on _RealtimeCommunicationType {
  static String get options =>
      _RealtimeCommunicationType.values.map((e) => e.toString()).join(' | ');
}

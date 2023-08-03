part of '../commands/create_command.dart';

class _CreateCommandArgumentsValueProvider {
  _CreateCommandArgumentsValueProvider(this.arguments, this._logger);

  final ArgResults arguments;
  final Logger _logger;

  /// endregion

  _ProjectGenerationArguments generate() {
    final interactive = arguments.isInteractiveConfigurationEnabled;
    final reader = interactive
        ? _CommandArgsLogReader(_logger)
        : _CommandArgsResultsReader(arguments);

    final read = reader.read;

    return _ProjectGenerationArguments(
      outputDirectory: arguments.outputDirectory,
      projectName: read(_CommandArgument.projectName, _validateProjectName),
      organisation: read(_CommandArgument.organisation, _validateOrganisation),
      enableAnalytics: read(_CommandArgument.analytics),
      enableCounter: read(_CommandArgument.counter),
      enableDeeplink: read(_CommandArgument.deepLink),
      enableWidgetToolkit: read(_CommandArgument.widgetToolkit),
      enableLogin: read(_CommandArgument.login),
      enableSocialLogins: read(_CommandArgument.socialLogins),
      enableChangeLanguage: read(_CommandArgument.changeLanguage),
      enableDevMenu: read(_CommandArgument.devMenu),
      enableOtp: read(_CommandArgument.otp),
      enablePatrolTests: read(_CommandArgument.patrol),
      realtimeCommunication: read(_CommandArgument.realtimeCommunication),
    );
  }

  String _validateProjectName(String name) {
    final _packageNameRegExp = RegExp('[a-z_][a-z0-9_]*');
    final isValidProjectName = _stringMatchesRegex(_packageNameRegExp, name);
    if (!isValidProjectName) {
      throw Exception(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
      );
    }
    return name;
  }

  String _validateOrganisation(String orgName) {
    if (orgName.trim().isEmpty) {
      throw Exception('No organisation name specified.');
    }

    final _orgNameDomainRegExp =
        RegExp('^([A-Za-z]{2,6})(\\.(?!-)[A-Za-z0-9-]{1,63}(?<!-))+\$');
    if (!_stringMatchesRegex(_orgNameDomainRegExp, orgName)) {
      throw Exception('Invalid organisation name.');
    }
    return orgName;
  }

  bool _stringMatchesRegex(RegExp regex, String name) {
    final match = regex.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }
}

extension _PromptTextProvider on _CommandArgument {
  String get prompt => switch (this) {
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
          'Select realtime communication type [ ${_OptionsProvider.options} ]:',
        _CommandArgument.socialLogins => 'Enable social logins:',
        _CommandArgument.widgetToolkit => 'Enable widget toolkit showcase:',
        _CommandArgument.interactive => throw UnsupportedError(
            'This option is not supported for interactive input'),
      };
}

extension _OptionsProvider on _RealtimeCommunicationType {
  static String get options =>
      _RealtimeCommunicationType.values.map((e) => e.toString()).join(' | ');
}

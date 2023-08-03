part of '../commands/create_command.dart';

class _CreateCommandArgumentsValueProvider {
  _CreateCommandArgumentsValueProvider(ArgResults arguments, Logger logger)
      : _outputDirectory = arguments.outputDirectory,
        _reader = arguments.isInteractiveConfigurationEnabled
            ? _LogReader(logger)
            : _ArgResultsReader(arguments);

  final Directory _outputDirectory;
  final _CommandArgumentsReader _reader;

  /// endregion

  _ProjectGenerationArguments generate() {
    final read = _reader.read;

    final projectName = read(
      _CommandArgument.projectName,
      validation: _validateProjectName,
    );
    final organisation = read(
      _CommandArgument.organisation,
      validation: _validateOrganisation,
    );

    return _ProjectGenerationArguments(
      outputDirectory: _outputDirectory,
      projectName: projectName,
      organisation: organisation,
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

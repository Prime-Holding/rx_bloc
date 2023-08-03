part of '../commands/create_command.dart';

class _CreateCommandArgumentsValueProvider {
  _CreateCommandArgumentsValueProvider(this.arguments, this.command);

  final ArgResults arguments;
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
      projectName: _parseProjectName(arguments),
      organisation: _parseOrganisation(arguments),
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
    throw UnimplementedError();
  }

  /// Gets the project name.
  String _parseProjectName(ArgResults arguments) {
    final projectName = arguments.stringOrDefault(_CommandArgument.projectName);
    _validateProjectName(projectName);
    return projectName;
  }

  /// Returns the organization name with domain in front of it
  String _parseOrganisation(ArgResults arguments) {
    final value = arguments.stringOrDefault(_CommandArgument.organisation);
    _validateOrganisation(value);
    return value;
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

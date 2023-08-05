part of '../generator_arguments_provider.dart';

class _ProjectConfigurationProvider {
  _ProjectConfigurationProvider(this._reader);

  final CommandArgumentsReader _reader;

  ProjectConfiguration read() {
    // Project name
    final projectName = _reader.read(CommandArguments.projectName,
        validation: _validateProjectName);

    // Organisation
    final organisation = _reader.read(CommandArguments.organisation,
        validation: _validateOrganisation);

    return ProjectConfiguration(
      projectName: projectName,
      organisation: organisation,
    );
  }

  String _validateProjectName(String name) {
    final projectNameRegex = '[a-z_][a-z0-9_]*';
    if (!name.matches(regex: projectNameRegex)) {
      throw CommandUsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
      );
    }
    return name;
  }

  String _validateOrganisation(String orgName) {
    final organisationRegex =
        '^([A-Za-z]{2,6})(\\.(?!-)[A-Za-z0-9-]{1,63}(?<!-))+\$';
    if (orgName.trim().isEmpty) {
      throw CommandUsageException('No organisation name specified.');
    }
    if (!orgName.matches(regex: organisationRegex)) {
      throw CommandUsageException('Invalid organisation name.');
    }
    return orgName;
  }
}

extension _StringMatchesRegex on String {
  /// Check if string matches a provided regex
  bool matches({required String regex}) {
    final regExp = RegExp(regex);
    final match = regExp.matchAsPrefix(this);
    return match != null && match.end == length;
  }
}

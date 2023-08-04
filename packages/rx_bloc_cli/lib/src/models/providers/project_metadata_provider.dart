part of '../generator_arguments_provider.dart';

class _ProjectMetadataProvider {
  _ProjectMetadataProvider(this._reader, this._logger);

  final CommandArgumentsReader _reader;
  final Logger _logger;

  _ProjectMetadataArguments read() {
    // Project name
    final projectName = _reader.read(
      CommandArguments.projectName,
      validation: _validateProjectName,
    );

    // Organisation
    final organisation = _reader.read(
      CommandArguments.organisation,
      validation: _validateOrganisation,
    );

    // Organisation name
    final organisationName =
        organisation.substring(organisation.indexOf('.') + 1);

    // Organisation Domain
    final organisationDomain =
        organisation.substring(0, organisation.indexOf('.'));

    return _ProjectMetadataArguments(
      projectName: projectName,
      organisation: organisation,
      organisationName: organisationName,
      organisationDomain: organisationDomain,
    );
  }

  String _validateProjectName(String name) {
    final regex = '[a-z_][a-z0-9_]*';
    if (!name.matches(regex: regex)) {
      throw CommandUsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
      );
    }
    return name;
  }

  String _validateOrganisation(String orgName) {
    final regex = '^([A-Za-z]{2,6})(\\.(?!-)[A-Za-z0-9-]{1,63}(?<!-))+\$';
    if (orgName.trim().isEmpty) {
      throw CommandUsageException('No organisation name specified.');
    }
    if (!orgName.matches(regex: regex)) {
      throw CommandUsageException('Invalid organisation name.');
    }
    return orgName;
  }
}

class _ProjectMetadataArguments {
  _ProjectMetadataArguments({
    required this.projectName,
    required this.organisation,
    required this.organisationName,
    required this.organisationDomain,
  });

  final String projectName;
  final String organisation;
  final String organisationName;
  final String organisationDomain;
}

extension _StringMatchesRegex on String {
  /// Check if string matches a provided regex
  bool matches({required String regex}) {
    final regExp = RegExp(regex);
    final match = regExp.matchAsPrefix(this);
    return match != null && match.end == length;
  }
}

import 'package:rx_bloc_cli/src/extensions/string_extensions.dart';

import '../errors/command_usage_exception.dart';

/// Project Configuration
class ProjectConfiguration {
  /// ProjectConfiguration constructor
  ProjectConfiguration({
    required this.projectName,
    required this.organisation,
  })  : organisationName =
            organisation.substring(organisation.indexOf('.') + 1),
        organisationDomain =
            organisation.substring(0, organisation.indexOf('.'));

  /// Project name
  final String projectName;

  /// Organisation
  final String organisation;

  /// Organisation name
  final String organisationName;

  /// Organisation domain
  final String organisationDomain;
}

/// Validations for project configuration
extension ProjectConfigurationValidations on ProjectConfiguration {
  /// Validates the provided project name
  static String validateProjectName(String name) {
    final projectNameRegex = r'[a-z_][a-z0-9_]*';
    if (!name.matches(regex: projectNameRegex)) {
      throw CommandUsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
      );
    }
    return name;
  }

  /// Validates the provided organisation
  static String validateOrganisation(String orgName) {
    final organisationRegex =
        r'^([A-Za-z]{2,6})(\.(?!-)[A-Za-z0-9-]{1,63}(?<!-))+$';
    if (orgName.trim().isEmpty) {
      throw CommandUsageException('No organisation name specified.');
    }
    if (!orgName.matches(regex: organisationRegex)) {
      throw CommandUsageException('Invalid organisation name.');
    }
    return orgName;
  }
}

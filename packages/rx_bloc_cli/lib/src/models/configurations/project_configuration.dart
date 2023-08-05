/// Contains configuration data for the project
class ProjectConfiguration {
  /// Constructor with projectName and organisation parameters
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

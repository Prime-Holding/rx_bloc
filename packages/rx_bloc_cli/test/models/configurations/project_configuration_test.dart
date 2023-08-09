import 'package:rx_bloc_cli/src/models/configurations/project_configuration.dart';
import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';
import 'package:test/test.dart';

import '../../stub.dart';

void main() {
  late ProjectConfiguration sut;

  group('test project_configuration', () {
    test('should compute the correct organisation name and domain', () {
      sut = ProjectConfiguration(
        projectName: Stub.projectName,
        organisation: Stub.organisation,
      );

      expect(sut.organisationName, equals(Stub.organisationName));
      expect(sut.organisationDomain, equals(Stub.organisationDomain));
    });
  });

  group('test project_configuration_validations', () {
    test('should validate project name', () {
      final validate = ProjectConfigurationValidations.validateProjectName;

      expect(validate(Stub.projectName), equals(Stub.projectName));

      expect(() => validate(Stub.empty), throwsA(isA<CommandUsageException>()));
      expect(() => validate(Stub.invalidProjectNameCapitalLetter),
          throwsA(isA<CommandUsageException>()));
      expect(() => validate(Stub.invalidProjectNameDigit),
          throwsA(isA<CommandUsageException>()));
    });

    test('should validate organisation', () {
      final validate = ProjectConfigurationValidations.validateOrganisation;

      expect(validate(Stub.organisation), equals(Stub.organisation));

      expect(() => validate(Stub.empty), throwsA(isA<CommandUsageException>()));
      expect(() => validate(Stub.invalidOrganisation),
          throwsA(isA<CommandUsageException>()));
    });
  });
}

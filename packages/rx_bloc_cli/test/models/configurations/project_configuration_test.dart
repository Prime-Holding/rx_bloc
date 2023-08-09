import 'package:rx_bloc_cli/src/models/configurations/project_configuration.dart';
import 'package:rx_bloc_cli/src/models/errors/command_usage_exception.dart';
import 'package:test/test.dart';

void main() {
  late ProjectConfiguration sut;

  group('test project_configuration', () {
    test('should compute the correct organisation name and domain', () {
      sut = ProjectConfiguration(
        projectName: 'testapp',
        organisation: 'com.primeholding',
      );

      expect(sut.organisationName, equals('primeholding'));
      expect(sut.organisationDomain, equals('com'));
    });
  });

  group('test project_configuration_validations', () {
    test('should validate project name', () {
      final validate = ProjectConfigurationValidations.validateProjectName;

      expect(validate('testapp'), equals('testapp'));

      expect(() => validate(''), throwsA(isA<CommandUsageException>()));
      expect(() => validate('Testapp'), throwsA(isA<CommandUsageException>()));
      expect(() => validate('1testapp'), throwsA(isA<CommandUsageException>()));
    });

    test('should validate organisation', () {
      final validate = ProjectConfigurationValidations.validateOrganisation;

      expect(validate('com.organisation'), equals('com.organisation'));

      expect(() => validate(''), throwsA(isA<CommandUsageException>()));
      expect(() => validate('c'), throwsA(isA<CommandUsageException>()));
      expect(() => validate('c.org'), throwsA(isA<CommandUsageException>()));
    });
  });
}

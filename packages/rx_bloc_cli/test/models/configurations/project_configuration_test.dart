import 'package:rx_bloc_cli/src/models/configurations/project_configuration.dart';
import 'package:test/test.dart';

void main() {
  late ProjectConfiguration sut;

  group('test feature_configuration', () {
    test('should compute the correct organisation name and domain', () {
      sut = ProjectConfiguration(
        projectName: 'testapp',
        organisation: 'com.primeholding',
      );

      expect(sut.organisationName, 'primeholding');
      expect(sut.organisationDomain, 'com');
    });
  });
}

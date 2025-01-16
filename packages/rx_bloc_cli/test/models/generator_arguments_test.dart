import 'dart:io';

import 'package:rx_bloc_cli/src/models/configurations/auth_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/feature_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/project_configuration.dart';
import 'package:rx_bloc_cli/src/models/configurations/showcase_configuration.dart';
import 'package:rx_bloc_cli/src/models/generator_arguments.dart';
import 'package:test/test.dart';

import '../stub.dart';

void main() {
  late Directory outputDirectory;
  late ProjectConfiguration projectConfiguration;
  late AuthConfiguration authConfiguration;
  late FeatureConfiguration featureConfiguration;
  late ShowcaseConfiguration showcaseConfiguration;
  late GeneratorArguments sut;

  setUp(() {
    outputDirectory = Directory('directory_path');
    projectConfiguration = ProjectConfiguration(
      projectName: Stub.projectName,
      organisation: Stub.defaultOrganisation,
    );
    authConfiguration = AuthConfiguration(
      loginEnabled: true,
      socialLoginsEnabled: true,
      otpEnabled: true,
      pinCodeEnabled: true,
      mfaEnabled: true,
    );
    featureConfiguration = FeatureConfiguration(
      changeLanguageEnabled: true,
      remoteTranslationsEnabled: true,
      analyticsEnabled: true,
      pushNotificationsEnabled: true,
      realtimeCommunicationEnabled: true,
      devMenuEnabled: true,
      patrolTestsEnabled: true,
      cicdEnabled: true,
      cicdGithubEnabled: true,
      cicdCodemagicEnabled: true,
      profileEnabled: true,
      onboardingEnabled: true,
    );
    showcaseConfiguration = ShowcaseConfiguration(
      counterEnabled: true,
      widgetToolkitEnabled: true,
      qrScannerEnabled: true,
      deepLinkEnabled: true,
      mfaEnabled: true,
      otpEnabled: true,
    );
    sut = GeneratorArguments(
      outputDirectory: outputDirectory,
      projectConfiguration: projectConfiguration,
      authConfiguration: authConfiguration,
      featureConfiguration: featureConfiguration,
      showcaseConfiguration: showcaseConfiguration,
    );
  });

  group('test generator_arguments values', () {
    test('should return all values without any modifications', () {
      expect(sut.outputDirectory.path, equals(outputDirectory.path));

      expect(sut.projectName, equals(projectConfiguration.projectName));
      expect(sut.organisation, equals(projectConfiguration.organisation));
      expect(
          sut.organisationName, equals(projectConfiguration.organisationName));
      expect(sut.organisationDomain,
          equals(projectConfiguration.organisationDomain));

      expect(sut.loginEnabled, equals(authConfiguration.loginEnabled));
      expect(sut.socialLoginsEnabled,
          equals(authConfiguration.socialLoginsEnabled));
      expect(sut.otpEnabled, equals(authConfiguration.otpEnabled));
      expect(sut.pinCodeEnabled, equals(authConfiguration.pinCodeEnabled));
      expect(sut.authenticationEnabled,
          equals(authConfiguration.authenticationEnabled));

      expect(sut.changeLanguageEnabled,
          equals(featureConfiguration.changeLanguageEnabled));
      expect(sut.counterEnabled, equals(showcaseConfiguration.counterEnabled));
      expect(
          sut.deepLinkEnabled, equals(showcaseConfiguration.deepLinkEnabled));
      expect(sut.devMenuEnabled, equals(featureConfiguration.devMenuEnabled));
      expect(sut.patrolTestsEnabled,
          equals(featureConfiguration.patrolTestsEnabled));
      expect(sut.usesFirebase, equals(featureConfiguration.usesFirebase));
      expect(sut.pushNotificationsEnabled,
          equals(featureConfiguration.pushNotificationsEnabled));
      expect(
          sut.analyticsEnabled, equals(featureConfiguration.analyticsEnabled));
      expect(sut.realtimeCommunicationEnabled,
          equals(featureConfiguration.realtimeCommunicationEnabled));
      expect(sut.widgetToolkitEnabled,
          equals(showcaseConfiguration.widgetToolkitEnabled));

      expect(sut.cicdEnabled, equals(featureConfiguration.cicdEnabled));
      expect(sut.cicdGithubEnabled,
          equals(featureConfiguration.cicdGithubEnabled));
      expect(sut.cicdCodemagicEnabled,
          equals(featureConfiguration.cicdCodemagicEnabled));
      expect(
          sut.qrScannerEnabled, equals(showcaseConfiguration.qrScannerEnabled));

      expect(sut.profileEnabled, equals(featureConfiguration.profileEnabled));
      expect(sut.onboardingEnabled,
          equals(featureConfiguration.onboardingEnabled));
    });
  });
}

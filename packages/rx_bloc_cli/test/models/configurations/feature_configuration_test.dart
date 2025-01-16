import 'package:rx_bloc_cli/src/models/configurations/feature_configuration.dart';
import 'package:test/test.dart';

void main() {
  late FeatureConfiguration sut;

  group('test feature_configuration', () {
    test(
        'should have usesFirebase enabled if '
        'analytics or push notifications are enabled', () {
      sut = FeatureConfiguration(
        changeLanguageEnabled: false,
        analyticsEnabled: false,
        pushNotificationsEnabled: true,
        realtimeCommunicationEnabled: false,
        devMenuEnabled: false,
        patrolTestsEnabled: false,
        cicdEnabled: false,
        cicdGithubEnabled: false,
        cicdCodemagicEnabled: false,
        profileEnabled: false,
        remoteTranslationsEnabled: false,
        onboardingEnabled: false,
      );
      expect(sut.usesFirebase, isTrue);

      sut = FeatureConfiguration(
        changeLanguageEnabled: false,
        analyticsEnabled: true,
        pushNotificationsEnabled: false,
        realtimeCommunicationEnabled: false,
        devMenuEnabled: false,
        patrolTestsEnabled: false,
        cicdEnabled: false,
        cicdGithubEnabled: false,
        cicdCodemagicEnabled: false,
        profileEnabled: false,
        remoteTranslationsEnabled: false,
        onboardingEnabled: false,
      );
      expect(sut.usesFirebase, isTrue);

      sut = FeatureConfiguration(
        changeLanguageEnabled: false,
        analyticsEnabled: true,
        pushNotificationsEnabled: true,
        realtimeCommunicationEnabled: false,
        devMenuEnabled: false,
        patrolTestsEnabled: false,
        cicdEnabled: false,
        cicdGithubEnabled: false,
        cicdCodemagicEnabled: false,
        profileEnabled: false,
        remoteTranslationsEnabled: false,
        onboardingEnabled: false,
      );
      expect(sut.usesFirebase, isTrue);

      sut = FeatureConfiguration(
        changeLanguageEnabled: false,
        analyticsEnabled: false,
        pushNotificationsEnabled: false,
        realtimeCommunicationEnabled: false,
        devMenuEnabled: false,
        patrolTestsEnabled: false,
        cicdEnabled: false,
        cicdGithubEnabled: false,
        cicdCodemagicEnabled: false,
        profileEnabled: false,
        remoteTranslationsEnabled: false,
        onboardingEnabled: false,
      );
      expect(sut.usesFirebase, isFalse);
    });
  });
}

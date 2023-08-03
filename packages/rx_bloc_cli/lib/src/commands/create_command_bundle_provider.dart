part of 'create_command.dart';

class _CreateCommandBundleProvider {
  _CreateCommandBundleProvider(this.arguments);

  final _counterBundle = featureCounterBundle;
  final _deepLinkBundle = featureDeeplinkBundle;
  final _widgetToolkitBundle = featureWidgetToolkitBundle;
  final _libRouterBundle = libRouterBundle;
  final _permissionsBundle = libPermissionsBundle;
  final _libAuthBundle = libAuthBundle;
  final _featureLoginBundle = featureLoginBundle;
  final _libSocialLoginsBundle = libSocialLoginsBundle;
  final _libChangeLanguageBundle = libChangeLanguageBundle;
  final _libDevMenuBundle = libDevMenuBundle;
  final _patrolIntegrationTestsBundle = patrolIntegrationTestsBundle;
  final _libRealtimeCommunicationBundle = libRealtimeCommunicationBundle;
  final _featureOtpBundle = featureOtpBundle;

  final _CreateCommandArguments arguments;

  List<MasonBundle> generate() {
    var bundles = <MasonBundle>[
      _libRouterBundle,
      _permissionsBundle,
    ];

    // Add counter brick to _bundle when needed
    if (arguments.enableCounterFeature) {
      bundles.add(_counterBundle);
    }

    // Add widget toolkit brick to _bundle when needed
    if (arguments.enableWidgetToolkitFeature) {
      bundles.add(_widgetToolkitBundle);
    }

    // Add deep link brick to _bundle when needed
    if (arguments.enableDeeplinkFeature) {
      bundles.add(_deepLinkBundle);
    }

    // Add Feature Login brick to _bundle when needed
    if (arguments.enableLogin) {
      bundles.add(_featureLoginBundle);
    }

    // Add Social Logins brick to _bundle when needed
    if (arguments.enableSocialLogins) {
      bundles.add(_libSocialLoginsBundle);
    }

    // Add Change Language brick _bundle when needed
    if (arguments.enableChangeLanguage) {
      bundles.add(_libChangeLanguageBundle);
    }
    // Add Patrol tests brick to _bundle when needed
    if (arguments.enablePatrolTests) {
      bundles.add(_patrolIntegrationTestsBundle);
    }

    if (arguments.realtimeCommunicationType !=
        _RealtimeCommunicationType.none) {
      bundles.add(_libRealtimeCommunicationBundle);
    }

    // Add Dev Menu brick _bundle when needed
    if (arguments.enableDevMenu) {
      bundles.add(_libDevMenuBundle);
    }

    // Add feature OTP brick _bundle when needed
    if (arguments.enableOtpFeature) {
      bundles.add(_featureOtpBundle);
    }

    //Add lib_auth to _bundle when needed
    if (arguments.hasAuthentication) {
      bundles.add(_libAuthBundle);
    }

    return bundles;
  }
}

import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/templates/feature_cicd_fastlane_bundle.dart';
import 'package:rx_bloc_cli/src/templates/feature_profile_bundle.dart';
import 'package:rx_bloc_cli/src/templates/feature_qr_scanner_bundle.dart';
import 'package:rx_bloc_cli/src/templates/lib_pin_code_bundle.dart';

import '../templates/feature_counter_bundle.dart';
import '../templates/feature_deeplink_bundle.dart';
import '../templates/feature_login_bundle.dart';
import '../templates/feature_otp_bundle.dart';
import '../templates/feature_widget_toolkit_bundle.dart';
import '../templates/lib_analytics_bundle.dart';
import '../templates/lib_auth_bundle.dart';
import '../templates/lib_change_language_bundle.dart';
import '../templates/lib_dev_menu_bundle.dart';
import '../templates/lib_mfa_bundle.dart';
import '../templates/lib_permissions_bundle.dart';
import '../templates/lib_realtime_communication_bundle.dart';
import '../templates/lib_router_bundle.dart';
import '../templates/lib_social_logins_bundle.dart';
import '../templates/patrol_integration_tests_bundle.dart';
import 'generator_arguments.dart';

/// Generates MasonBundle with required files
class BundleGenerator {
  /// Constructor
  BundleGenerator(this._bundle);

  final MasonBundle _bundle;

  final _counterBundle = featureCounterBundle;
  final _qrScannerBundle = featureQrScannerBundle;
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
  final _libMfa = libMfaBundle;
  final _featureCICDFastlaneBundle = featureCicdFastlaneBundle;
  final _libPinCodeBundle = libPinCodeBundle;
  final _libAnalyticsBundle = libAnalyticsBundle;
  final _featureProfile = featureProfileBundle;

  /// Generates a bundles based on the specified arguments
  MasonBundle generate(GeneratorArguments arguments) {
    // Remove files when they are not needed by the specified features
    if (arguments.analyticsEnabled) {
      _bundle.files.addAll(_libAnalyticsBundle.files);
    } else {
      _bundle.files.removeWhere(
          (file) => file.path == BundleFilePaths.analyticsFilePath);
    }
    // Add counter brick to _bundle when needed
    if (arguments.counterEnabled) {
      _bundle.files.addAll(_counterBundle.files);
    }

    // Add qr scanner brick to _bundle when needed
    if (arguments.qrScannerEnabled) {
      _bundle.files.addAll(_qrScannerBundle.files);
    }

    // Add widget toolkit brick to _bundle when needed
    if (arguments.widgetToolkitEnabled) {
      _bundle.files.addAll(_widgetToolkitBundle.files);
    }

    // Add deep link brick to _bundle when needed
    if (arguments.deepLinkEnabled) {
      _bundle.files.addAll(_deepLinkBundle.files);
    }

    // Add Feature Login brick to _bundle when needed
    if (arguments.loginEnabled) {
      _bundle.files.addAll(_featureLoginBundle.files);
    }

    // Add Social Logins brick to _bundle when needed
    if (arguments.socialLoginsEnabled) {
      _bundle.files.addAll(_libSocialLoginsBundle.files);
    }

    // Add Change Language brick _bundle when needed
    if (arguments.changeLanguageEnabled) {
      _bundle.files.addAll(_libChangeLanguageBundle.files);
    }
    // Add Patrol tests brick to _bundle when needed
    if (arguments.patrolTestsEnabled) {
      _bundle.files.addAll(_patrolIntegrationTestsBundle.files);
    }

    if (arguments.realtimeCommunicationEnabled) {
      _bundle.files.addAll(_libRealtimeCommunicationBundle.files);
    }

    // Add Dev Menu brick _bundle when needed
    if (arguments.devMenuEnabled) {
      _bundle.files.addAll(_libDevMenuBundle.files);
    }
    // Add feature OTP brick _bundle when needed
    if (arguments.otpEnabled) {
      _bundle.files.addAll(_featureOtpBundle.files);
    }
    // Add PIN code brick _bundle when needed
    if (arguments.pinCodeEnabled) {
      _bundle.files.addAll(_libPinCodeBundle.files);
    }

    //Add lib_route to _bundle
    _bundle.files.addAll(_libRouterBundle.files);
    //Add lib_permissions to _bundle
    _bundle.files.addAll(_permissionsBundle.files);
    //Add lib_auth to _bundle when needed
    if (arguments.authenticationEnabled) {
      _bundle.files.addAll(_libAuthBundle.files);
    }
    // Add ci/cd files
    if (arguments.cicdEnabled) {
      _bundle.files.addAll(_featureCICDFastlaneBundle.files);
    }
    //Add lib_mfa to _bundle when needed
    if (arguments.mfaEnabled) {
      _bundle.files.addAll(_libMfa.files);
    }
    //Add feature_profile to _bundle when needed
    if (arguments.profileEnabled) {
      _bundle.files.addAll(_featureProfile.files);
    }
    return _bundle;
  }
}

/// Excluded file paths
extension BundleFilePaths on BundleGenerator {
  /// Analytics file path
  static const analyticsFilePath =
      'lib/base/data_sources/remote/interceptors/analytics_interceptor.dart';
}

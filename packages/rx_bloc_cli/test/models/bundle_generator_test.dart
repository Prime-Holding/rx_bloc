import 'package:mason/mason.dart';
import 'package:rx_bloc_cli/src/models/bundle_generator.dart';
import 'package:rx_bloc_cli/src/templates/feature_counter_bundle.dart';
import 'package:rx_bloc_cli/src/templates/feature_deeplink_bundle.dart';
import 'package:rx_bloc_cli/src/templates/feature_login_bundle.dart';
import 'package:rx_bloc_cli/src/templates/feature_otp_bundle.dart';
import 'package:rx_bloc_cli/src/templates/feature_widget_toolkit_bundle.dart';
import 'package:rx_bloc_cli/src/templates/lib_auth_bundle.dart';
import 'package:rx_bloc_cli/src/templates/lib_change_language_bundle.dart';
import 'package:rx_bloc_cli/src/templates/lib_dev_menu_bundle.dart';
import 'package:rx_bloc_cli/src/templates/lib_mfa_bundle.dart';
import 'package:rx_bloc_cli/src/templates/lib_permissions_bundle.dart';
import 'package:rx_bloc_cli/src/templates/lib_pin_code_bundle.dart';
import 'package:rx_bloc_cli/src/templates/lib_realtime_communication_bundle.dart';
import 'package:rx_bloc_cli/src/templates/lib_router_bundle.dart';
import 'package:rx_bloc_cli/src/templates/lib_social_logins_bundle.dart';
import 'package:rx_bloc_cli/src/templates/patrol_integration_tests_bundle.dart';
import 'package:rx_bloc_cli/src/templates/rx_bloc_base_bundle.dart';
import 'package:test/test.dart';

import '../stub.dart';

void main() {
  late BundleGenerator sut;

  late MasonBundle _baseBundle;

  final _counter = featureCounterBundle;
  final _deepLink = featureDeeplinkBundle;
  final _login = featureLoginBundle;
  final _otp = featureOtpBundle;
  final _widgetToolkit = featureWidgetToolkitBundle;
  final _libAuth = libAuthBundle;
  final _libMfa = libMfaBundle;
  final _libChangeLanguage = libChangeLanguageBundle;
  final _libDevMenu = libDevMenuBundle;
  final _libPermissions = libPermissionsBundle;
  final _libRouter = libRouterBundle;
  final _libSocialLogins = libSocialLoginsBundle;
  final _patrol = patrolIntegrationTestsBundle;
  final _libRealtimeCommunication = libRealtimeCommunicationBundle;
  final _pinCode = libPinCodeBundle;

  setUp(() {
    // Copy the base bundle to avoid polluted state between tests
    _baseBundle = rxBlocBaseBundle.copy();
    sut = BundleGenerator(_baseBundle);
  });

  group('test bundle_generator generate', () {
    test('should return all bundles if all flags enabled', () {
      final bundle = sut.generate(Stub.generatorArgumentsAllEnabled);
      final files = bundle.filePaths;

      final counterFiles = _counter.filePaths;
      expect(files.intersection(counterFiles), equals(counterFiles));

      final deepLinkFiles = _deepLink.filePaths;
      expect(files.intersection(deepLinkFiles), equals(deepLinkFiles));

      final loginFiles = _login.filePaths;
      expect(files.intersection(loginFiles), equals(loginFiles));

      final otpFiles = _otp.filePaths;
      expect(files.intersection(otpFiles), equals(otpFiles));

      final pinCodeFiles = _pinCode.filePaths;
      expect(files.intersection(pinCodeFiles), equals(pinCodeFiles));

      final widgetToolkitFiles = _widgetToolkit.filePaths;
      expect(
          files.intersection(widgetToolkitFiles), equals(widgetToolkitFiles));

      final authFiles = _libAuth.filePaths;
      expect(files.intersection(authFiles), equals(authFiles));

      final mfaFiles = _libMfa.filePaths;
      expect(files.intersection(mfaFiles), equals(mfaFiles));

      final changeLanguageFiles = _libChangeLanguage.filePaths;
      expect(
          files.intersection(changeLanguageFiles), equals(changeLanguageFiles));

      final devMenuFiles = _libDevMenu.filePaths;
      expect(files.intersection(devMenuFiles), equals(devMenuFiles));

      final permissionsFiles = _libPermissions.filePaths;
      expect(files.intersection(permissionsFiles), equals(permissionsFiles));

      final routerFiles = _libRouter.filePaths;
      expect(files.intersection(routerFiles), equals(routerFiles));

      final socialLoginsFiles = _libSocialLogins.filePaths;
      expect(files.intersection(socialLoginsFiles), equals(socialLoginsFiles));

      final patrolFiles = _patrol.filePaths;
      expect(files.intersection(patrolFiles), equals(patrolFiles));

      final realtimeCommunicationFiles = _libRealtimeCommunication.filePaths;
      expect(files.intersection(realtimeCommunicationFiles),
          equals(realtimeCommunicationFiles));

      expect(
          () => bundle.files.firstWhere(
              (element) => element.path == BundleFilePaths.analyticsFilePath),
          returnsNormally);
    });

    test('should return correct default bundles', () {
      final bundle = sut.generate(Stub.generatorArgumentsDefault);
      final files = bundle.filePaths;

      // Available Features

      final loginFiles = _login.filePaths;
      expect(files.intersection(loginFiles), equals(loginFiles));

      final routerFiles = _libRouter.filePaths;
      expect(files.intersection(routerFiles), equals(routerFiles));

      final authFiles = _libAuth.filePaths;
      expect(files.intersection(authFiles), equals(authFiles));

      final changeLanguageFiles = _libChangeLanguage.filePaths;
      expect(
          files.intersection(changeLanguageFiles), equals(changeLanguageFiles));

      final permissionsFiles = _libPermissions.filePaths;
      expect(files.intersection(permissionsFiles), equals(permissionsFiles));

      // Unavailable Features

      final otpFiles = _otp.filePaths;
      expect(files.intersection(otpFiles), isEmpty);

      final widgetToolkitFiles = _widgetToolkit.filePaths;
      expect(files.intersection(widgetToolkitFiles), isEmpty);

      final counterFiles = _counter.filePaths;
      expect(files.intersection(counterFiles), equals([Stub.licenseFileName]));

      final deepLinkFiles = _deepLink.filePaths;
      expect(files.intersection(deepLinkFiles), isEmpty);

      final devMenuFiles = _libDevMenu.filePaths;
      expect(files.intersection(devMenuFiles), isEmpty);

      final patrolFiles = _patrol.filePaths;
      expect(files.intersection(patrolFiles), isEmpty);

      final realtimeCommunicationFiles = _libRealtimeCommunication.filePaths;
      expect(files.intersection(realtimeCommunicationFiles), isEmpty);

      expect(
          () => bundle.files.firstWhere(
              (element) => element.path == BundleFilePaths.analyticsFilePath),
          throwsStateError);
    });
  });
}

extension _CopyMasonBundle on MasonBundle {
  MasonBundle copy() => MasonBundle.fromJson(toJson());

  Set<String> get filePaths => files.map((file) => file.path).toSet();
}

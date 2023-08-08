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
import 'package:rx_bloc_cli/src/templates/lib_permissions_bundle.dart';
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
  late MasonBundle _counter;
  late MasonBundle _deepLink;
  late MasonBundle _login;
  late MasonBundle _otp;
  late MasonBundle _widgetToolkit;
  late MasonBundle _libAuth;
  late MasonBundle _libChangeLanguage;
  late MasonBundle _libDevMenu;
  late MasonBundle _libPermissions;
  late MasonBundle _libRouter;
  late MasonBundle _libSocialLogins;
  late MasonBundle _patrol;
  late MasonBundle _libRealtimeCommunication;

  setUp(() {
    _baseBundle = rxBlocBaseBundle.copy();
    _counter = featureCounterBundle.copy();
    _deepLink = featureDeeplinkBundle.copy();
    _login = featureLoginBundle.copy();
    _otp = featureOtpBundle.copy();
    _widgetToolkit = featureWidgetToolkitBundle.copy();
    _libAuth = libAuthBundle.copy();
    _libChangeLanguage = libChangeLanguageBundle.copy();
    _libDevMenu = libDevMenuBundle.copy();
    _libPermissions = libPermissionsBundle.copy();
    _libRouter = libRouterBundle.copy();
    _libSocialLogins = libSocialLoginsBundle.copy();
    _patrol = patrolIntegrationTestsBundle.copy();
    _libRealtimeCommunication = libRealtimeCommunicationBundle.copy();


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

      final widgetToolkitFiles = _widgetToolkit.filePaths;
      expect(
          files.intersection(widgetToolkitFiles), equals(widgetToolkitFiles));

      final authFiles = _libAuth.filePaths;
      expect(files.intersection(authFiles), equals(authFiles));

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

      final realtimeCommunicationFiles =
          _libRealtimeCommunication.filePaths;
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
      expect(files.intersection(counterFiles), equals(['{{~ licence.dart }}']));

      final deepLinkFiles = _deepLink.filePaths;
      expect(files.intersection(deepLinkFiles), isEmpty);

      final devMenuFiles = _libDevMenu.filePaths;
      expect(files.intersection(devMenuFiles), isEmpty);

      final socialLoginsFiles = _libSocialLogins.filePaths;
      expect(files.intersection(socialLoginsFiles), isEmpty);

      final patrolFiles = _patrol.filePaths;
      expect(files.intersection(patrolFiles), isEmpty);

      final realtimeCommunicationFiles =
          _libRealtimeCommunication.filePaths;
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

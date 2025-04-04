import 'package:rx_bloc_cli/src/extensions/string_buffer_extensions.dart';

import '../common/abstract_processors.dart';

/// String processor used for processing an Info.plist file in the ios
/// directory found at: ios/Runner/Info.plist
class InfoPlistProcessor extends StringProcessor {
  /// Podfile file processor constructor
  InfoPlistProcessor(super.args);

  @override
  String execute() {
    if (input == null) return '';
    final buffer = StringBuffer(input!);

    if (args.qrScannerEnabled) {
      _updateInfoPlistPermissionsCamera(buffer);
    }
    if (args.pinCodeEnabled) {
      _updateInfoPlistPermissionsBiometrics(buffer);
    }
    if (args.deepLinkEnabled) {
      _updateInfoPlistDeepLink(buffer);
    }

    return buffer.toString();
  }

  void _updateInfoPlistPermissionsCamera(StringBuffer buffer) {
    const permissions = '''
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to scan QR codes</string>
 ''';
    buffer.insertBefore('</dict>', permissions);
  }

  void _updateInfoPlistPermissionsBiometrics(StringBuffer buffer) {
    const permissions = '''
    <key>NSFaceIDUsageDescription</key>
    <string>This app needs face id to use biometrics authentication</string>
    ''';
    buffer.insertBefore('</dict>', permissions);
  }

  void _updateInfoPlistDeepLink(StringBuffer buffer) {
    final _urlSchemes = '''<key>FlutterDeepLinkingEnabled</key>
    <false/>
    <key>CFBundleURLTypes</key>
    <array>
      <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>$packageId</string>
        <key>CFBundleURLSchemes</key>
        <array>
          <string>${args.projectName}</string>
        </array>
      </dict>
    </array>
    <key>LSApplicationQueriesSchemes</key>
    <array>
      <string>${args.projectName}</string>
      <string>message</string>
    </array>
    ''';
    buffer.insertBefore('</dict>', _urlSchemes);
  }
}

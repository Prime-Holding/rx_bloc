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

    //_updateGlobalIOSPlatform(buffer);
    if (args.qrScannerEnabled) {
      _updateInfoPlistPermissions(buffer);
    }

    return buffer.toString();
  }

  void _updateInfoPlistPermissions(StringBuffer buffer) {
    const permissions = '''
    <key>NSCameraUsageDescription</key>
    <string>Your message to user when the camera is accessed for the first time</string>
 ''';
    buffer.insertBefore('</dict>', permissions);
}
}

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
      _updateInfoPlistPermissions(buffer);
    }

    return buffer.toString();
  }

  void _updateInfoPlistPermissions(StringBuffer buffer) {
    const permissions = '''
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to scan QR codes</string>
 ''';
    buffer.insertBefore('</dict>', permissions);
  }
}

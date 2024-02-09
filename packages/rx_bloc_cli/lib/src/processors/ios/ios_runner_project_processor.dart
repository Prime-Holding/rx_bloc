import 'package:rx_bloc_cli/src/extensions/string_buffer_extensions.dart';

import '../common/abstract_processors.dart';

/// String processor used for processing the iOS project file located at:
/// ios/Runner.xcodeproj/project.pbxproj
class IOSRunnerProjectProcessor extends StringProcessor {
  /// iOS project file processor constructor
  IOSRunnerProjectProcessor(super.args);

  String get _bundleId =>
      '${args.organisationDomain}.${args.organisationName}.${args.projectName}';

  @override
  String execute() {
    if (input == null) return '';
    final buffer = StringBuffer(input!);

    _replaceValues(buffer);

    return buffer.toString();
  }

  /// region Private methods

  /// region Value Replacement methods

  /// Replaces values within the xcode project
  void _replaceValues(StringBuffer buffer) {
    _replaceBundleId(buffer);
    _replaceReleaseEntitlementsRefs(buffer);
  }

  /// Replaces missing bundle ids with project generated ones
  void _replaceBundleId(StringBuffer buffer) {
    const lookupText = 'PRODUCT_BUNDLE_IDENTIFIER = ';
    const runnerTests = 'RunnerTests';
    var sIndex = buffer.nthIndexOf(lookupText);
    if (sIndex < 0) return;
    var eIndex = -1;
    var readBundle = '';
    do {
      sIndex += lookupText.length;
      eIndex = buffer.nthIndexOf(';', start: sIndex);
      readBundle = buffer.toString().substring(sIndex, eIndex);
      if (!readBundle.contains(_bundleId)) {
        if (readBundle.endsWith(runnerTests)) {
          buffer.replaceRange(sIndex, eIndex, '$_bundleId.$runnerTests');
        } else {
          buffer.replaceRange(sIndex, eIndex, _bundleId);
        }
      }
      sIndex = buffer.nthIndexOf(lookupText, start: sIndex);
    } while (sIndex > -1);
  }

  /// Replaces entitlements for Release build modes with prod entitlements
  void _replaceReleaseEntitlementsRefs(StringBuffer buffer) {
    const lookupText = '''.xcconfig */;
			buildSettings = {''';
    const cse = 'CODE_SIGN_ENTITLEMENTS = ';
    var sIndex = buffer.nthIndexOf(lookupText);
    if (sIndex < 0) return;
    var eIndex = -1;
    var str = '';
    var buildConfig = '';
    do {
      str = buffer.toString();
      eIndex = buffer.nthIndexOf('}', start: sIndex);
      if (str.substring(sIndex, eIndex).contains(cse)) {
        buildConfig = str.substring(str.lastIndexOf('/* ', sIndex) + 3, sIndex);
        sIndex += lookupText.length;
        if (buildConfig.toLowerCase().contains('release')) {
          sIndex = buffer.nthIndexOf(cse, start: sIndex) + cse.length;
          sIndex = buffer.nthIndexOf('-dev', start: sIndex);
          buffer.replaceRange(sIndex, sIndex + 4, '-prod');
        }
      } else {
        sIndex += lookupText.length;
      }
      sIndex = buffer.nthIndexOf(lookupText, start: sIndex);
    } while (sIndex > -1);
  }

  /// endregion

  /// endregion
}

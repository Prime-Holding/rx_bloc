import 'package:rx_bloc_cli/src/extensions/string_buffer_extensions.dart';
import 'package:rx_bloc_cli/src/rx_bloc_cli_constants.dart';
import 'package:rx_bloc_cli/src/utils/flavor_generator.dart';

import '../common/abstract_processors.dart';

/// String processor used for processing an Podfile file in the ios
/// directory found at: ios/Podfile
class PodfileProcessor extends StringProcessor {
  /// Podfile file processor constructor
  PodfileProcessor(super.args);

  static const _minSupportedIOSVersion = '16.0';

  Map<String, String> get _buildModeMapping => {
        'Debug': 'debug',
        'Profile': 'release',
        'Release': 'release',
      };

  @override
  String execute() {
    if (input == null) return '';
    final buffer = StringBuffer(input!);

    _addBuildConfigurations(buffer);
    _updateGlobalIOSPlatform(buffer);
    _updateProjectRunnerModes(buffer);

    return buffer.toString();
  }

  /// region Private methods

  void _updateGlobalIOSPlatform(StringBuffer buffer) {
    final globalPlatformCommand = 'platform :ios';
    var replacement =
        buffer.toString().replaceAll('# platform :ios', globalPlatformCommand);

    // Update the minimum supported iOS version
    var startIndex =
        replacement.indexOf("'", replacement.indexOf(globalPlatformCommand));
    var endIndex = replacement.indexOf("'", startIndex + 1);
    if (startIndex >= 0 && endIndex >= 0 && endIndex > startIndex) {
      replacement = replacement.replaceRange(
          startIndex + 1, endIndex, _minSupportedIOSVersion);
    }

    buffer
      ..clear()
      ..write(replacement);
  }

  void _updateProjectRunnerModes(StringBuffer buffer) {
    const runnerConfigs = "project 'Runner'";
    const runnerConfigsComment =
        '# Each build configurations consist of the mode in which it is'
        ' launched and the flavor name.\n# Each configuration maps to either'
        ' the release or debug mode. The release mode has any associated \n#'
        ' debug symbols stripped from the generated application file.\n';
    final index = buffer.nthIndexOf('}',
            start: buffer.nthIndexOf(
              '{',
              start: buffer.nthIndexOf(runnerConfigs),
            )) -
        1;
    buffer
      ..insertAt(index, _buildConfigForSelectedFlavors())
      ..insertBefore(runnerConfigs, runnerConfigsComment);
  }

  void _addBuildConfigurations(StringBuffer buffer) {
    final deploymentTargetsConfig = '''\n
    target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '$_minSupportedIOSVersion'
        ${args.qrScannerEnabled ? '''
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
            '\$(inherited)',
            ## dart: PermissionGroup.camera
            'PERMISSION_CAMERA=1',
        ]''' : ''}
    end
''';
    const additionalBuildSettingsConfig =
        'flutter_additional_ios_build_settings(target)';

    buffer.insertAfter(additionalBuildSettingsConfig, deploymentTargetsConfig);
  }

  String _buildConfigForSelectedFlavors() =>
      FlavorGenerator.getFlavors(args).fold(
          '',
          (previousValue, element) =>
              previousValue + _buildConfigForFlavor(element));

  String _buildConfigForFlavor(String flavor) => kIOSBuildModes
      .map((mode) => _buildSingleConfigForFlavor(flavor, mode))
      .fold('', (prev, cur) => prev + cur);

  String _buildSingleConfigForFlavor(String flavor, String buildMode) =>
      "\n  '$buildMode-$flavor' => :${_buildModeMapping[buildMode]},";

  /// endregion
}

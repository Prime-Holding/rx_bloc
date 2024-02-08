import 'package:rx_bloc_cli/src/extensions/string_buffer_extensions.dart';
import 'package:rx_bloc_cli/src/rx_bloc_cli_constants.dart';
import 'package:rx_bloc_cli/src/utils/flavor_generator.dart';

import '../common/abstract_processors.dart';

/// String processor used for processing an Podfile file in the ios
/// directory found at: ios/Podfile
class PodfileProcessor extends StringProcessor {
  /// Podfile file processor constructor
  PodfileProcessor(super.args);

  Map<String, String> get _buildModeMapping => {
        'Debug': 'debug',
        'Profile': 'release',
        'Release': 'release',
      };

  @override
  String execute() {
    if (input == null) return '';
    final buffer = StringBuffer(input!);

    _updateGlobalIOSPlatform(buffer);
    _updateProjectRunnerModes(buffer);

    return buffer.toString();
  }

  /// region Private methods

  void _updateGlobalIOSPlatform(StringBuffer buffer) {
    final replacement =
        buffer.toString().replaceAll('# platform :ios', 'platform :ios');
    buffer
      ..clear()
      ..write(replacement);
  }

  void _updateProjectRunnerModes(StringBuffer buffer) {
    const runnerConfigs = "project 'Runner'";
    const runnerConfigsComment =
        '# Map each flavor configuration to a build mode\n';
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

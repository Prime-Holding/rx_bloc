import 'package:rx_bloc_cli/src/extensions/string_buffer_extensions.dart';

import '../common/abstract_processors.dart';

/// String processor used for processing an Podfile file in the ios
/// directory found at: ios/Podfile
class PodfileProcessor extends StringProcessor {
  /// Podfile file processor constructor
  PodfileProcessor(super.args);

  @override
  String execute() {
    if (input == null) return '';
    final buffer = StringBuffer(input!);

    _updateProjectRunnerModes(buffer);

    return buffer.toString();
  }

  /// region Private methods

  void _updateProjectRunnerModes(StringBuffer buffer) {
    final index = buffer.nthIndexOf('}',
            start: buffer.nthIndexOf(
              '{',
              start: buffer.nthIndexOf("project 'Runner'"),
            )) -
        1;
    buffer.insertAt(index, _buildConfigForSelectedFlavors());
  }

  String _buildConfigForSelectedFlavors() => {'prod', 'dev', 'sit', 'uat'}.fold(
      '',
      (previousValue, element) =>
          previousValue + _buildConfigForFlavor(element));

  String _buildConfigForFlavor(String flavor) =>
      '''\n  'Debug-$flavor' => :debug,
  'Profile-$flavor' => :release,
  'Release-$flavor' => :release,''';

  /// endregion
}

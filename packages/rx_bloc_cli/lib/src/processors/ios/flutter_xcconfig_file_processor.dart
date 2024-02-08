import 'package:rx_bloc_cli/src/extensions/string_buffer_extensions.dart';

import '../../rx_bloc_cli_constants.dart';
import '../common/abstract_processors.dart';

/// String processor used for processing an iOS XCConfig file in the flutter
/// directory found at: ios/Flutter/*.xcconfig
class FlutterXCConfigFileProcessor extends StringProcessor {
  /// iOS Flutter XCConfig file processor constructor
  FlutterXCConfigFileProcessor(
    super.args,
    this.configType,
  );

  /// Type of the configuration file (flavor + build mode)
  final String configType;

  @override
  String execute() {
    if (input == null) return '';
    final buffer = StringBuffer(input!);

    _insertMissingHeaders(buffer);
    _updateConfigValues(buffer);

    return buffer.toString();
  }

  /// region Private methods

  (String, String) _separateFlavorAndBuildMode() {
    final mode = kIOSBuildModes.firstWhere(configType.contains);
    final flavor = configType.replaceAll(mode, '');
    return (flavor, mode);
  }

  void _insertMissingHeaders(StringBuffer buffer) {
    const headerImport =
        '#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.';
    if (buffer.toString().contains(headerImport)) return;

    final (flavor, mode) = _separateFlavorAndBuildMode();
    var configSection = mode.toLowerCase();
    if (flavor.trim() != '') {
      configSection += '-${flavor.toLowerCase()}';
    }

    buffer.insertAt(0, '$headerImport$configSection.xcconfig"\n');
  }

  void _replaceFlutterTarget(
    StringBuffer buffer,
    String oldName,
    String newName,
  ) {
    const pattern = 'FLUTTER_TARGET=lib/main_###.dart';
    if (buffer.nthIndexOf(pattern.replaceAll('###', oldName)) < 0) return;

    final replacement = buffer.toString().replaceAll(
        pattern.replaceAll('###', oldName), pattern.replaceAll('###', newName));
    buffer
      ..clear()
      ..write(replacement);
  }

  void _updateConfigValues(StringBuffer buffer) {
    _replaceFlutterTarget(buffer, 'development', 'dev');
    _replaceFlutterTarget(buffer, 'production', 'prod');
  }

  /// endregion
}

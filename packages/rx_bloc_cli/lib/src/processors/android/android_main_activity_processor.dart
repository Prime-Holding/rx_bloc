import 'package:rx_bloc_cli/src/extensions/string_buffer_extensions.dart';

import '../common/abstract_processors.dart';

/// String processor used for processing of the MainActivity.kt file located at:
/// {project_root}/android/app/src/main/kotlin/{organisationDomain}/{organisationName}/{projectName}/MainActivity.kt
class AndroidMainActivityProcessor extends StringProcessor {
  /// Android MainActivity processor constructor
  AndroidMainActivityProcessor(super.args);

  @override
  String execute() {
    if (input == null) return '';
    final buffer = StringBuffer(input!);

    if (args.pinCodeEnabled) {
      _addPinCodeSupport(buffer);
    }

    return buffer.toString();
  }

  /// region Private methods
  void _addPinCodeSupport(StringBuffer buffer) {
    const oldImport = 'import io.flutter.embedding.android.FlutterActivity';
    const newImport =
        'import io.flutter.embedding.android.FlutterFragmentActivity';
    final startIndex = buffer.toString().indexOf(oldImport);
    if (startIndex != -1) {
      buffer.replaceRange(startIndex, startIndex + oldImport.length, newImport);
    }

    const oldClass = 'class MainActivity : FlutterActivity()';
    const newClass = 'class MainActivity : FlutterFragmentActivity()';
    final classStartIndex = buffer.toString().indexOf(oldClass);
    if (classStartIndex != -1) {
      buffer.replaceRange(
          classStartIndex, classStartIndex + oldClass.length, newClass);
    }
  }

  /// endregion
}

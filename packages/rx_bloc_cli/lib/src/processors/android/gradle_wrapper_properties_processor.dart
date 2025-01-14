import 'package:rx_bloc_cli/src/extensions/string_buffer_extensions.dart';
import 'package:rx_bloc_cli/src/rx_bloc_cli_constants.dart';

import '../common/abstract_processors.dart';

/// String processor used for processing android/app/build.gradle file
class GradleWrapperPropertiesProcessor extends StringProcessor {
  /// Android app build gradle processor constructor
  GradleWrapperPropertiesProcessor(super.args);

  @override
  String execute() {
    if (input == null) return '';
    final buffer = StringBuffer(input!);

    _modifyValues(buffer);

    return buffer.toString();
  }

  /// region Private methods

  void _modifyValues(
    StringBuffer buffer, {
    String gradleWrapperUrl = kGradleWrapperUrl,
  }) {
    void _replaceVal(String content, String replacement) {
      final start = buffer.nthIndexOf(content);
      if (start < 0) return;
      final end = start + content.length;
      buffer.replaceRange(start, end, replacement);
    }

    void _replaceQuotedVal(
      String content,
      String replacement, {
      int start = 0,
    }) {
      final start = buffer.nthIndexOf(content);
      final sIndex = buffer.nthIndexOf('=',
              start: buffer.nthIndexOf(content, start: start)) +
          1;
      if (sIndex < 0) return;
      final eIndex = buffer.nthIndexOf('\n', start: sIndex);
      buffer.replaceRange(sIndex, eIndex, replacement);
    }

    _replaceQuotedVal('distributionUrl', gradleWrapperUrl);
  }
  /// endregion
}

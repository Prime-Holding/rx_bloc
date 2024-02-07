import 'package:rx_bloc_cli/src/extensions/string_buffer_extensions.dart';

import '../common/abstract_processors.dart';

/// String processor used for processing android/build.gradle file
class AndroidBuildGradleProcessor extends StringProcessor {
  /// Android build gradle processor constructor
  AndroidBuildGradleProcessor(super.args);

  @override
  String execute() {
    if (input == null) return '';
    final buffer = StringBuffer(input!);

    if (args.analyticsEnabled) {
      _applyAnalyticsOptions(buffer);
    }

    return buffer.toString();
  }

  void _applyAnalyticsOptions(StringBuffer buffer) {
    final (start, end) = buffer.getGradleSectionLastLineRange('dependencies');
    final content = '''
\n        classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.9'
    ''';
    buffer.replaceRange(start, end, content);
  }
}

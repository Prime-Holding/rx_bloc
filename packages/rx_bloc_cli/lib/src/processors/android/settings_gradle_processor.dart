import 'package:rx_bloc_cli/src/extensions/string_buffer_extensions.dart';
import 'package:rx_bloc_cli/src/rx_bloc_cli_constants.dart';

import '../common/abstract_processors.dart';

/// String processor used for processing android/app/build.gradle file
class SettingsGradle extends StringProcessor {
  /// Android app build gradle processor constructor
  SettingsGradle(super.args);

  @override
  String execute() {
    if (input == null) return '';
    final buffer = StringBuffer(input!);

    _modifyValues(buffer);

    if (args.analyticsEnabled) {
      _applyAnalyticsOptions(buffer);
    }

    return buffer.toString();
  }

  /// region Private methods

  void _applyAnalyticsOptions(StringBuffer buffer) {
    final (start, end) = buffer.getGradleSectionLastLineRange('plugins');
    final content = '''
\n    id("com.google.gms.google-services") version "4.3.15" apply false
\n    id("com.google.firebase.crashlytics") version "2.8.1" apply false
    ''';
    buffer.replaceRange(start, end, content);
  }

  void _modifyValues(
    StringBuffer buffer, {
    String gradlePluginVersion = kGradlePluginVersion,
  }) {
    void _replaceQuotedVal(
      String content,
      String replacement, {
      int start = 0,
    }) {
      final versionString = 'version "';
      final sIndex = buffer.nthIndexOf(versionString,
              start: buffer.nthIndexOf(content, start: start)) +
          versionString.length;
      if (sIndex < 0) return;
      final eIndex = buffer.nthIndexOf('"', start: sIndex);
      buffer.replaceRange(sIndex, eIndex, replacement);
    }

    _replaceQuotedVal('com.android.application', gradlePluginVersion);
  }

  /// endregion
}

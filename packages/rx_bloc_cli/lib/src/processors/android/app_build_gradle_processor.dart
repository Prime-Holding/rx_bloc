import '../common/string_processor.dart';

/// String processor used for processing android/app/build.gradle file
class AppBuildGradleProcessor extends StringProcessor {
  String get _tabSpace => '    ';

  @override
  String execute(String? input) {
    if (input == null) return '';
    final buffer = StringBuffer();

    // Parse the android/app/build.gradle file here

    return buffer.toString();
  }
}

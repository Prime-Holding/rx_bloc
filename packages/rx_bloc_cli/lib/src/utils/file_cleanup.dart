import 'dart:io';

/// Helper class used for cleaning up any redundant files after generation phase
class FileCleanup {
  static final _dirsToRemove = [
    'lib/pages/',
    '.tmp/',
    'setup_scripts/',
    'android/environments/',
  ];
  static final _filesToRemove = [
    '.idea/runConfigurations/main_dart.xml',
    'test/widget_test.dart',
    'lib/main.dart',
    'lib/app.dart',
    'lib/flavors.dart',
    'flavorizr.yaml',
    'assets.tmp.zip',
  ];

  static List<String> get _itemsToRemove => [
        ..._filesToRemove,
        ..._dirsToRemove,
      ];

  /// Remove any generated files that are not needed (such as files created
  /// using the `flutter create` command or by-products of adding flavors)
  static Future<void> postGenerationCleanup(
    Directory outputDirectory, {
    List<String>? filesToRemove,
  }) async {
    final _toRemove = List<String>.from(_itemsToRemove);
    if (filesToRemove != null) _toRemove.addAll(filesToRemove);
    final projectPath = '${outputDirectory.absolute.path}/';

    for (var path in _toRemove) {
      try {
        if (path.endsWith('/')) {
          await Directory('$projectPath$path').delete(recursive: true);
        } else {
          await File('$projectPath$path').delete();
        }
      } catch (_) {}
    }
  }
}

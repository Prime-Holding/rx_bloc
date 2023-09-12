import 'dart:io';

// ignore_for_file: unused_local_variable

/// Enum used to make a distinction between different types of generated
/// gitignore files.
enum GitignoreType {
  /// Gitignore placed at the project root level
  project,

  /// Gitignore placed inside the devops directory
  devops;

  /// Contents of the gitignore file
  String get fileContents => switch (this) {
        GitignoreType.project => _projectGitIgnore,
        GitignoreType.devops => _devopsGitIgnore,
      };
}

/// Used for creation of .gitignore files
class GitIgnoreCreator {
  /// Default constructor of the git ignore file creator
  GitIgnoreCreator();

  /// Generates a .gitignore file at the specified path
  static void generate(
    String path, {
    GitignoreType gitignore = GitignoreType.project,
  }) {
    final file = File('$path/.gitignore')
      ..writeAsStringSync(
        gitignore.fileContents,
      );
  }
}

/// GitIgnore placed at the root of the project
String _projectGitIgnore = '''
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
pubspec.lock

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# Flutter/Dart/Pub related
**/doc/api/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/
.fvm/

# Generated code
lib/generated_plugin_registrant.dart
lib/assets.dart

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Exceptions to above rules.
!/packages/flutter_tools/test/data/dart_dependencies_test/**/.packages

# local env
env.json
lib/env_variable.g.dart

# Android related
**/android/**/gradle-wrapper.jar
**/android/.gradle
**/android/captures/
**/android/gradlew
**/android/gradlew.bat
**/android/local.properties
**/android/key.properties
**/android/**/GeneratedPluginRegistrant.java

# iOS/XCode related
**/ios/**/*.mode1v3
**/ios/**/*.mode2v3
**/ios/**/*.moved-aside
**/ios/**/*.pbxuser
**/ios/**/*.perspectivev3
**/ios/**/*sync/
**/ios/**/.sconsign.dblite
**/ios/**/.tags*
**/ios/**/.vagrant/
**/ios/**/DerivedData/
**/ios/**/Icon?
**/ios/**/Pods/
**/ios/**/.symlinks/
**/ios/**/profile
**/ios/**/xcuserdata
**/ios/.generated/
**/ios/Flutter/App.framework
**/ios/Flutter/Flutter.framework
**/ios/Flutter/Generated.xcconfig
**/ios/Flutter/app.flx
**/ios/Flutter/app.zip
**/ios/Flutter/flutter_assets/
**/ios/ServiceDefinitions.json
**/ios/Runner/GeneratedPluginRegistrant.*

# Exceptions to above rules.
!**/ios/**/default.mode1v3
!**/ios/**/default.mode2v3
!**/ios/**/default.pbxuser
!**/ios/**/default.perspectivev3
''';

final _devopsGitIgnore = '''
# Ignored files
.DS_Store
*.jks
*.txt
*.p8
*.p12
*.mobileprovision
*.json

# Ignored directories
credentials/
artifacts/
decoded/
''';

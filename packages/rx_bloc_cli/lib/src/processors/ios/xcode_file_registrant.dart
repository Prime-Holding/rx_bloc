import 'dart:io';

import '../common/abstract_processors.dart';

/// Class used for registering files/directories within XCode
class XCodeFileRegistrant extends VoidProcessor {
  /// XCode File Registrant default constructor
  XCodeFileRegistrant(super.args);

  /// Directories to register within Xcode. The directories are registered
  /// within Xcode groups. The parameters in the tuple are as follow:
  /// 1. Directory to be registered within the Xcode project
  /// 2. The Xcode group to be added to (or main group if null)
  List<(String, String?)> get _dirsToRegister => [
        ('environments/', null),
      ];

  /// Files to register within Xcode. The parameters in the tuple are as follow:
  /// 1. File to be registered within the Xcode project
  /// 2. Flag indicating whether we are adding to a directory or a Xcode group
  /// 3. The destination where to add the file, within the Xcode main group
  List<(String, bool, String?)> get _filesToRegister => [
        ('ios/Runner/GoogleService-Info.plist', true, 'Runner'),
      ];

  @override
  Future<void> execute() async {
    for (var tpl in _dirsToRegister) {
      await _registerDirectory(tpl.$1, tpl.$2);
    }

    for (var tpl in _filesToRegister) {
      await _registerFile(tpl.$1, tpl.$2, tpl.$3);
    }
  }

  /// region Helper methods

  Future<void> _registerFile(
    String filePath,
    bool isDirectory,
    String? groupName,
  ) =>
      Process.run(
        'ruby',
        [
          'setup_scripts/register_file_in_xcode.rb',
          'ios/Runner.xcodeproj',
          '$isDirectory',
          filePath,
          if (groupName != null) groupName,
        ],
        workingDirectory: args.outputDirectory.path,
      );

  Future<void> _registerDirectory(
    String directoryPath,
    String? groupName,
  ) =>
      Process.run(
        'ruby',
        [
          'setup_scripts/register_directory_in_xcode.rb',
          'ios/Runner.xcodeproj',
          directoryPath,
          if (groupName != null) groupName,
        ],
        workingDirectory: args.outputDirectory.path,
      );

  /// endregion
}

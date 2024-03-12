import 'dart:io';

import 'abstract_processors.dart';

/// Processor used for handling shell scripts
class ShellScriptProcessor extends VoidProcessor {
  /// Default shell script processor constructor
  ShellScriptProcessor(
    super.args, {
    this.scripts = const [],
  });

  /// List of script files to be processed by this processor
  final List<String> scripts;

  @override
  void execute() {
    // Update execution permission of each script
    for (var script in scripts) {
      _updateShellScriptExecutePermission(script);
    }
  }

  /// Updates shell script to gain execution permission
  Future<void> _updateShellScriptExecutePermission(String filePath) async {
    await Process.run(
      'chmod',
      [
        '+x',
        '${args.outputDirectory.absolute.path}/$filePath',
      ],
    );
  }
}

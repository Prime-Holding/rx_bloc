import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  // Add your post-generation code here
  // (Code executed immediately after the generation step)

  //Builds generated packages
  if (context.vars['enable_feature_counter'] == false) {
    final formatProgress = context.logger.progress(
        'Running "dart pub run build_runner build --delete-conflicting-outputs"');
    await Process.run('dart', ['pub', 'get']);
    await Process.run('dart', [
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ]);
    await Process.run('dart', ['format', '.']);
    formatProgress.complete();
  }
}

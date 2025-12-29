import 'dart:developer';
import 'dart:io';
import 'dart:convert';

/// Merges multiple ARB files per locale into single ARB files
/// This allows organizing translations by feature while Flutter gen-l10n
/// requires one ARB file per locale
///
///
///
/// Future<void> main(List<String> args) async {
/// await _flushThenExit(await RxBlocCommandRunner().run(args));
///}
void main() {
  final sourcesDir = Directory('lib/l10n/sources');
  final outputDir = Directory('lib/l10n');
  final locales = ['en', 'bg'];

  if (!sourcesDir.existsSync()) {
    log('Error: lib/l10n/sources directory not found');
    exit(1);
  }

  for (final locale in locales) {
    // Start with app file from sources if it exists, otherwise create empty map
    Map<String, dynamic> merged = {};
    final appFile = File('${sourcesDir.path}/intl_$locale.arb');

    if (appFile.existsSync()) {
      try {
        merged = jsonDecode(appFile.readAsStringSync());
        // Remove @@locale from app file as we'll add it at the end
        merged.remove('@@locale');
        log('Starting with intl_$locale.arb from sources');
      } catch (e) {
        log('Error reading intl_$locale.arb from sources: $e');
        merged = {};
      }
    } else {
      log('No intl_$locale.arb found in sources, starting fresh');
    }

    // Find all feature ARB files for this locale in sources directory (excluding app files)
    final featureFiles = sourcesDir
        .listSync()
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('_$locale.arb') &&
              !file.path.contains('intl_$locale.arb'),
        )
        .toList();

    // Merge all feature files
    for (final file in featureFiles) {
      try {
        final content =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        // Merge content - feature files override app file values
        for (final key in content.keys) {
          if (merged.containsKey(key) && merged[key] != content[key]) {
            log(
              'Overriding key "$key" from app file with value from ${file.path.split('/').last}',
            );
          }
          merged[key] = content[key];
        }
        log('Merged ${file.path.split('/').last} into intl_$locale.arb');
      } catch (e) {
        log('Error merging ${file.path}: $e');
      }
    }

    // Ensure @@locale metadata is present
    merged['@@locale'] = locale;

    // Write the merged file to lib/l10n (where gen-l10n expects it)
    final outputFile = File('${outputDir.path}/intl_$locale.arb');
    outputFile.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(merged),
    );
    log('Created merged ${outputFile.path}');
  }

  log('\nMerging complete! You can now run: flutter gen-l10n');
}

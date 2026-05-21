import 'dart:convert';
import 'dart:io';

const _sourcesDir = 'lib/l10n/sources';
const _referenceLocale = 'en';

void main() {
  final dir = Directory(_sourcesDir);
  if (!dir.existsSync()) {
    print('Error: $_sourcesDir directory not found');
    exit(1);
  }

  final arbFiles = dir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb'))
      .toList();

  // Collect unique prefixes from filenames like {prefix}_{locale}.arb
  final prefixes = <String>{};
  for (final file in arbFiles) {
    final name = file.uri.pathSegments.last; // e.g. "error_en.arb"
    final withoutExt = name.substring(0, name.length - 4); // "error_en"
    final lastUnderscore = withoutExt.lastIndexOf('_');
    if (lastUnderscore < 1) continue;
    prefixes.add(withoutExt.substring(0, lastUnderscore)); // "error"
  }

  for (final prefix in (prefixes.toList()..sort())) {
    final referenceFile = File('$_sourcesDir/${prefix}_$_referenceLocale.arb');
    if (!referenceFile.existsSync()) continue;

    print('[synchronizing $prefix]');
    _sync(dir, prefix, referenceFile);
  }
}

void _sync(Directory dir, String prefix, File referenceFile) {
  final reference =
      jsonDecode(referenceFile.readAsStringSync()) as Map<String, dynamic>;

  final targets = dir
      .listSync()
      .whereType<File>()
      .where(
        (f) =>
            f.uri.pathSegments.last.startsWith('${prefix}_') &&
            f.path.endsWith('.arb') &&
            f.path != referenceFile.path,
      )
      .toList();

  for (final target in targets) {
    final originalContent = target.readAsStringSync();
    final current = jsonDecode(originalContent) as Map<String, dynamic>;

    // Build result preserving key order from the reference file.
    // Keys present in reference but missing in target are filled with the
    // reference (English) value. All other keys keep their existing value.
    final result = <String, dynamic>{};
    for (final key in reference.keys) {
      result[key] = current.containsKey(key) ? current[key] : reference[key];
    }

    final newContent = const JsonEncoder.withIndent('  ').convert(result);
    final filename = target.uri.pathSegments.last;

    if (newContent != originalContent) {
      target.writeAsStringSync(newContent);
      print('  $filename ... done');
    } else {
      print('  $filename ... no changes');
    }
  }
}

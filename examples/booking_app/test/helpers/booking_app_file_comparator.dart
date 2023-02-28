import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class BookingAppFileComparator extends LocalFileComparator {
  static const double _kGoldenDiffTolerance = 0.0041;

  BookingAppFileComparator(String testFile)
      : super(Uri.parse(_getTestFile(testFile)));

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final dsa = Uri.parse(golden.path.split('/').last);

    final ComparisonResult result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(dsa),
    );

    if (!result.passed && result.diffPercent > _kGoldenDiffTolerance) {
      final String error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    if (!result.passed) {
      log('A tolerable difference of ${result.diffPercent * 100}% was found when '
          'comparing $golden.');
    }
    return result.passed || result.diffPercent <= _kGoldenDiffTolerance;
  }

  static String _getTestFile(String fileName) {
    final baseDir =
        (goldenFileComparator as LocalFileComparator).basedir.path.split('/');

    baseDir.removeWhere(
      (element) => ['goldens', 'light_theme', 'dark_theme'].contains(element),
    );

    return '${baseDir.join('/')}$fileName';
  }
}

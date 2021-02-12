// ignore_for_file: directives_ordering

import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:test/test.dart';
import 'test_builder.dart' as _i2;
import 'package:source_gen/builder.dart' as _i3;
import 'package:build_config/build_config.dart' as _i4;
import 'dart:isolate' as _i5;
import 'package:build_runner/build_runner.dart' as _i6;
import 'dart:io' as _i7;

final _builders = <_i1.BuilderApplication>[
  _i1.apply('rx_bloc_generator:rx_block', [_i2.testBuilder], _i1.toRoot(),
      hideOutput: false),
];

void main() async {
  test('shodafsdj ajsdj fa', () async {
    var result = await _i6.run(['build'], _builders);
    print(result);
    // sendPort?.send(result);
    // _i7.exitCode = result;
  });
}

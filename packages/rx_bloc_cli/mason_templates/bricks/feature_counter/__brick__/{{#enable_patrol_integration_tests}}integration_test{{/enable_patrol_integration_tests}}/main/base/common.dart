
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

export 'package:flutter_test/flutter_test.dart';
export 'package:patrol/patrol.dart';
export 'package:widget_toolkit/widget_toolkit.dart';

const _patrolTesterConfig = PatrolTesterConfig();
const _nativeAutomatorConfig = NativeAutomatorConfig();

void patrol(
  String description,
  Future<void> Function(PatrolTester) callback, {
  bool? skip,
}) {
  patrolTest(
    description,
    callback,
    config: _patrolTesterConfig,
    nativeAutomatorConfig: _nativeAutomatorConfig,
    nativeAutomation: true,
    skip: skip,
  );
}

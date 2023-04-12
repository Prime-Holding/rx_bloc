import 'package:flutter_test/flutter_test.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../factory/sample_factory.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';


void main() {
  runGoldenTests([
    generateDeviceBuilder(
        widget: sampleFactory(), //example: Stubs.emptyList
        scenario: Scenario(name: 'sample_empty')),
    generateDeviceBuilder(
        widget: sampleFactory(), //example:  Stubs.success
        scenario: Scenario(name: 'sample_success')),
    generateDeviceBuilder(
        widget: sampleFactory(), //loading
        scenario: Scenario(name: 'sample_loading')),
    generateDeviceBuilder(
        widget: sampleFactory(),
        scenario: Scenario(name: 'sample_error'))
  ]);
}
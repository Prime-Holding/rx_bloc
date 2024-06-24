import '../../Stubs.dart';
import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../factory/statistics_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
        widget: statisticsFactory(todosStats: Stubs.todoListStatisticsEmpty),
        //example: Stubs.emptyList
        scenario: Scenario(name: 'statistics_empty')),
    generateDeviceBuilder(
        widget: statisticsFactory(todosStats: Stubs.todoListStatistics), //example:  Stubs.success
        scenario: Scenario(name: 'statistics_success')),
    generateDeviceBuilder(
        widget: statisticsFactory(), //loading
        scenario: Scenario(name: 'statistics_loading')),
  ]);
}

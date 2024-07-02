import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../../stubs.dart';
import '../factory/statistics_factory.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
        widget: statisticsFactory(todosStats: Stubs.todoListStatisticsEmpty),
        scenario: Scenario(name: 'statistics_empty')),
    generateDeviceBuilder(
        widget: statisticsFactory(todosStats: Stubs.todoListStatistics),
        scenario: Scenario(name: 'statistics_success')),
    generateDeviceBuilder(
        widget: statisticsFactory(),
        scenario: Scenario(name: 'statistics_loading')),
  ]);
}

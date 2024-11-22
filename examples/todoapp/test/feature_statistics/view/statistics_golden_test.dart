import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../factory/statistics_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'statistics_empty',
      widget: statisticsFactory(
        todosStats: Stubs.todoListStatisticsEmpty,
      ),
    ),
    buildScenario(
      scenario: 'statistics_success',
      widget: statisticsFactory(
        todosStats: Stubs.todoListStatistics,
      ),
    ),
    buildScenario(
      scenario: 'statistics_loading',
      widget: statisticsFactory(),
    ),
  ]);
}

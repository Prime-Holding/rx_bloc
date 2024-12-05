import 'package:rx_bloc/rx_bloc.dart';

import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../factory/dashboard_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(widget: dashboardFactory(), scenario: 'dashboard_empty'),
    buildScenario(
        widget: dashboardFactory(
          dashboardCounters: Result.success(Stubs.dashboardCountersModel),
          reminderModels: Stubs.reminderPaginatedList,
        ), //example:  Stubs.success
        scenario: 'dashboard_success'),
    buildScenario(
        widget: dashboardFactory(dashboardCounters: Result.loading()),
        scenario: 'dashboard_loading',
        customPumpBeforeTest: (tester) =>
            tester.pump(const Duration(milliseconds: 300))),
    buildScenario(
        widget: dashboardFactory(
            dashboardCounters: Result.error(Stubs.throwable),
            errors: Stubs.errorNoConnection),
        scenario: 'dashboard_error')
  ]);
}

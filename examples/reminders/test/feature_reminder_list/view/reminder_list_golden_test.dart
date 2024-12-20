import '../../helpers/golden_helper.dart';
import '../../stubs.dart';
import '../factory/reminder_list_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
        widget: reminderListFactory(paginatedList: Stubs.paginatedListEmpty),
        scenario: 'reminder_list_empty'),
    buildScenario(
        widget: reminderListFactory(paginatedList: Stubs.reminderPaginatedList),
        scenario: 'reminder_list_success'),
    buildScenario(
        widget: reminderListFactory(
            paginatedList: Stubs.paginatedListEmpty.copyWith(
          isLoading: true,
          isInitialized: false,
        )),
        scenario: 'reminder_list_loading'),
    buildScenario(
        widget: reminderListFactory(errors: 'Error occur'),
        scenario: 'reminder_list_error')
  ]);
}

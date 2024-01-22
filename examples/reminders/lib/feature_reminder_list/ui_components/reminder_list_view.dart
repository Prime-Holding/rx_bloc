import 'package:flutter/material.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

import '../../base/common_ui_components/app_progress_indicator.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../blocs/reminder_list_bloc.dart';
import 'reminder_list_scroll_view.dart';

/// Widget that uses a RxPaginatedBuilder to create a paginated list of
/// reminders, with refresh functionality and different views for success,
/// loading, and error states
class ReminderListView extends StatelessWidget {
  const ReminderListView({
    this.createdReminderId,
    super.key,
  });

  /// The id of the reminder that was just created to be scrolled to
  final String? createdReminderId;

  @override
  Widget build(BuildContext context) => RxPaginatedBuilder<ReminderListBlocType,
          ReminderModel>.withRefreshIndicator(
        state: (bloc) => bloc.states.paginatedList,
        onBottomScrolled: (bloc) => bloc.events.loadPage(),
        onRefresh: (bloc) async {
          bloc.events.loadPage(reset: true);
          return bloc.states.refreshDone;
        },
        buildSuccess: (context, list, bloc) => ReminderListScrollView(
          remindersList: list,
          scrollToReminderId: createdReminderId,
        ),
        buildLoading: (context, list, bloc) => const AppProgressIndicator(),
        buildError: (context, list, bloc) => Container(),
      );
}

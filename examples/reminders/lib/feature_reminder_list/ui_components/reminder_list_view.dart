import 'package:flutter/material.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

import '../../base/common_ui_components/app_progress_indicator.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../blocs/reminder_list_bloc.dart';
import 'scroll_to_index_widget.dart';

class ReminderListView extends StatelessWidget {
  const ReminderListView({
    this.createdReminderId,
    super.key,
  });

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

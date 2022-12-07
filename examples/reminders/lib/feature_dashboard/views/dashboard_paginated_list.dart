import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

import '../../base/common_ui_components/app_progress_indicator.dart';
import '../../base/common_ui_components/app_reminder_tile.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../feature_reminder_manage/blocs/reminder_manage_bloc.dart';
import '../blocs/dashboard_bloc.dart';

class DashboardPaginatedList extends StatelessWidget {
  const DashboardPaginatedList({super.key});

  @override
  Widget build(BuildContext context) =>
      RxPaginatedBuilder<DashboardBlocType, ReminderModel>.withRefreshIndicator(
        state: (bloc) => bloc.states.reminderModels,
        onBottomScrolled: (bloc) =>
            bloc.events.fetchDataPaginated(silently: false),
        onRefresh: (bloc) async {
          bloc.events.fetchDataPaginated(silently: true);
          return bloc.states.refreshDone;
        },
        buildSuccess: (context, list, bloc) => _buildSuccess(list),
        buildLoading: (context, list, bloc) => const AppProgressIndicator(),
        buildError: (context, list, bloc) => Container(),
      );

  Widget _buildSuccess(PaginatedList<ReminderModel> list) => ListView.builder(
        itemBuilder: (context, index) {
          ReminderModel? item = list.getItem(index);
          if (item == null) {
            return const AppProgressIndicator();
          }

          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: AppReminderTile(
              reminder: item,
              isFirst: index == 0,
              isLast: index == list.length - 1,
              onDueDateChanged: (date) => context
                  .read<ReminderManageBlocType>()
                  .events
                  .update(item.copyWith(
                    dueDate: date,
                  )),
              onTitleChanged: (title) => context
                  .read<ReminderManageBlocType>()
                  .events
                  .update(item.copyWith(
                    title: title,
                  )),
              onCompleteChanged: (complete) => context
                  .read<ReminderManageBlocType>()
                  .events
                  .update(item.copyWith(
                    complete: complete,
                  )),
              onDeletePressed: () =>
                  context.read<ReminderManageBlocType>().events.delete(item),
            ),
          );
        },
        itemCount: list.itemCount,
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_reminder_tile.dart';
import '../../base/common_ui_components/app_sticky_header.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../blocs/reminder_list_bloc.dart';

class ReminderListView extends StatelessWidget {
  const ReminderListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RxPaginatedBuilder<ReminderListBlocType,
          ReminderModel>.withRefreshIndicator(
        state: (bloc) => bloc.states.paginatedList,
        onBottomScrolled: (bloc) => bloc.events.loadPage(),
        onRefresh: (bloc) async {
          bloc.events.loadPage(reset: true);
          return bloc.states.refreshDone;
        },
        buildSuccess: (context, list, bloc) => CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverStickyHeader(
              header: AppStickyHeader(
                text: 'Today',
                color: context.designSystem.colors.secondaryColor,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => AppReminderTile(
                    reminder: list[i],
                    isLast: i == (list.length - 1),
                  ),
                  childCount: list.totalCount,
                ),
              ),
            ),
            SliverStickyHeader(
              header: AppStickyHeader(
                text: 'This month',
                color: context.designSystem.colors.secondaryColor,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => AppReminderTile(
                    reminder: ReminderModel.fromIndex(i),
                    isLast: i == 13,
                  ),
                  childCount: 14,
                ),
              ),
            )
          ],
        ),
        buildLoading: (context, list, bloc) =>
            const CircularProgressIndicator(),
        buildError: (context, list, bloc) => Container(),
      );
}

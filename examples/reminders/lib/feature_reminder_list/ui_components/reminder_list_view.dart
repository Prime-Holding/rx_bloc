import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_reminder_tile.dart';
import '../../base/common_ui_components/app_sticky_header.dart';
import '../../base/models/reminder_model.dart';

class ReminderListView extends StatelessWidget {
  const ReminderListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                reminder: ReminderModel.fromIndex(i),
                isLast: i == 3,
              ),
              childCount: 4,
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
    );
  }
}

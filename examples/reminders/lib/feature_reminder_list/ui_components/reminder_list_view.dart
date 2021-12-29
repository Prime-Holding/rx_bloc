import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

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
          header: const AppStickyHeader(
            text: 'edno',
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => AppReminderTile(
                reminder: ReminderModel.fromIndex(i),
              ),
              childCount: 4,
            ),
          ),
        ),
        SliverStickyHeader(
          header: const AppStickyHeader(
            text: 'dve',
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => AppReminderTile(
                reminder: ReminderModel.fromIndex(i),
              ),
              childCount: 14,
            ),
          ),
        )
      ],
    );
  }
}

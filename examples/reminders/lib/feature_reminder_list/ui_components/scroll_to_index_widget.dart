import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:scroll_pos/scroll_pos.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_reminder_tile.dart';
import '../../base/common_ui_components/app_sticky_header.dart';
import '../../base/models/reminder/reminder_model.dart';

class ScrollToPositionWidget extends StatefulWidget {
  const ScrollToPositionWidget({
    required this.remindersList,
    this.createdReminderId,
    Key? key,
  }) : super(key: key);

  final PaginatedList<ReminderModel> remindersList;
  final String? createdReminderId;

  @override
  State<ScrollToPositionWidget> createState() => _ScrollToPositionWidgetState();
}

class _ScrollToPositionWidgetState extends State<ScrollToPositionWidget> {
  late final ScrollPosController _controller;

  @override
  void initState() {
    _controller = ScrollPosController(itemCount: widget.remindersList.length);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ScrollToPositionWidget oldWidget) {
    if (widget.createdReminderId != null &&
        oldWidget.createdReminderId != widget.createdReminderId) {
      final _correctIndex = widget.remindersList
          .indexWhere((element) => element.id == widget.createdReminderId);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _controller.scrollToItem(_correctIndex);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
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
                reminder: widget.remindersList.list[i],
                isLast: i == (widget.remindersList.length - 1),
                key: ValueKey(i),
              ),
              childCount: widget.remindersList.list.length,
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
        ),
      ],
    );
  }
}

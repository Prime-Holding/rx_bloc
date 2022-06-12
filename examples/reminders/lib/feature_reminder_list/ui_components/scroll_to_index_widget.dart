import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_reminder_tile.dart';
import '../../base/common_ui_components/app_sticky_header.dart';
import '../../base/models/reminder/reminder_model.dart';

class ReminderListScrollView extends StatefulWidget {
  const ReminderListScrollView({
    required this.remindersList,
    this.scrollToReminderId,
    Key? key,
  }) : super(key: key);

  final PaginatedList<ReminderModel> remindersList;
  final String? scrollToReminderId;

  @override
  State<ReminderListScrollView> createState() => _ReminderListScrollViewState();
}

class _ReminderListScrollViewState extends State<ReminderListScrollView> {
  late final AutoScrollController _controller;

  @override
  void initState() {
    _controller = AutoScrollController();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ReminderListScrollView oldWidget) {
    if (widget.scrollToReminderId != null &&
        oldWidget.scrollToReminderId != widget.scrollToReminderId) {
      final _correctIndex = widget.remindersList
          .indexWhere((element) => element.id == widget.scrollToReminderId);
      _controller.scrollToIndex(
        _correctIndex,
        duration: const Duration(milliseconds: 50),
        preferPosition: AutoScrollPosition.middle,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
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
                (context, i) => AutoScrollTag(
                  controller: _controller,
                  index: i,
                  key: ValueKey(i),
                  child: AppReminderTile(
                    reminder: widget.remindersList.list[i],
                    isLast: i == (widget.remindersList.length - 1),
                  ),
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
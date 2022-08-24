import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:rx_bloc_list/models.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_progress_indicator.dart';
import '../../base/common_ui_components/app_reminder_tile.dart';
import '../../base/models/reminder/reminder_model.dart';

enum Group { overdue, today, thisMonth, inFuture }

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
  static const _overdue = 'Overdue';
  static const _today = 'Today';
  static const _thisMonth = 'This month';
  static const _inFuture = 'In future';

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
  Widget build(BuildContext context) => GroupedListView<ReminderModel, Group>(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        useStickyGroupSeparators: true,
        elements: widget.remindersList.list,
        groupBy: _groupBy,
        groupComparator: (value1, value2) =>
            value1.index.compareTo(value2.index),
        groupSeparatorBuilder: _groupSeparatorBuilder,
        indexedItemBuilder: (context, ReminderModel reminder, int index) {
          final item = widget.remindersList.getItem(index + 1);

          if (item == null &&
              widget.remindersList.hasNextPage &&
              widget.remindersList.isNextPageLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: 12),
              child: AppProgressIndicator(),
            );
          }
          return _itemBuilder(index, reminder);
        },
      );

  Widget _itemBuilder(int index, ReminderModel reminder) => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: AutoScrollTag(
          controller: _controller,
          index: index,
          key: ValueKey(index),
          child: AppReminderTile(
            reminder: reminder,
            isFirst: index == 0,
            isLast: index == widget.remindersList.totalCount! - 1,
          ),
        ),
      );

  Widget _groupSeparatorBuilder(Group type) {
    var title = '';
    if (type == Group.overdue) {
      title = _overdue;
    } else if (type == Group.today) {
      title = _today;
    } else if (type == Group.thisMonth) {
      title = _thisMonth;
    } else if (type == Group.inFuture) {
      title = _inFuture;
    }

    return Container(
      height: 45,
      padding: const EdgeInsets.only(left: 24, top: 8.5,bottom: 8.5),
      color: context.designSystem.colors.backgroundListColor,
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      ),
    );
  }

  Group _groupBy(ReminderModel element) {
    final date = DateTime(
      element.dueDate.year,
      element.dueDate.month,
      element.dueDate.day,
    );
    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );
    var isBeforeToday = date.isBefore(today);
    var isToday = date.isAtSameMomentAs(today);
    var thisYearMonth = DateTime(now.year, now.month, now.day);
    var isThisMonth = date.month == now.month;
    var isAfterThisMonth = date.isAfter(thisYearMonth);
    Group groupTitle = Group.overdue;
    if (isBeforeToday) {
      groupTitle = Group.overdue;
    } else if (isToday) {
      groupTitle = Group.today;
    } else if (isThisMonth) {
      groupTitle = Group.thisMonth;
    } else if (isAfterThisMonth) {
      groupTitle = Group.inFuture;
    }
    return groupTitle;
  }
}

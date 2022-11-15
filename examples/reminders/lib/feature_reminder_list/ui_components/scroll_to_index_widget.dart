import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_progress_indicator.dart';
import '../../base/common_ui_components/app_reminder_tile.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../feature_reminder_manage/blocs/reminder_manage_bloc.dart';

enum Group { overdue, today, thisMonth, inFuture }

class ReminderListScrollView extends StatefulWidget {
  const ReminderListScrollView({
    required this.remindersList,
    this.scrollToReminderId,
    super.key,
  });

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
      final correctIndex = widget.remindersList
          .indexWhere((element) => element.id == widget.scrollToReminderId);
      if (correctIndex != -1) {
        _controller.scrollToIndex(
          correctIndex,
          duration: const Duration(milliseconds: 50),
          preferPosition: AutoScrollPosition.middle,
        );
      }
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
        sort: false,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        useStickyGroupSeparators: true,
        floatingHeader: false,
        elements: widget.remindersList.list,
        groupBy: _groupBy,
        itemComparator: (ReminderModel value1, ReminderModel value2) =>
            value1.dueDate.compareTo(value2.dueDate),
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
          key: ValueKey(reminder.id),
          child: AppReminderTile(
            reminder: reminder,
            isFirst: _firstInGroup(index, reminder),
            isLast: _isLastInGroup(index, reminder),
            onDueDateChanged: (date) => context
                .read<ReminderManageBlocType>()
                .events
                .update(reminder.copyWith(
                  dueDate: date,
                )),
            onTitleChanged: (title) => context
                .read<ReminderManageBlocType>()
                .events
                .update(reminder.copyWith(
                  title: title,
                )),
            onCompleteChanged: (complete) => context
                .read<ReminderManageBlocType>()
                .events
                .update(reminder.copyWith(
                  complete: complete,
                )),
            onDeletePressed: () =>
                context.read<ReminderManageBlocType>().events.delete(reminder),
          ),
        ),
      );

  bool _firstInGroup(int index, ReminderModel reminder) {
    if (index == 0) {
      return true;
    }
    if (index < widget.remindersList.length) {
      var prev = _groupBy(widget.remindersList[index > 0 ? index - 1 : 0]).name;
      var currGroup = _groupBy(reminder).name;
      return prev != currGroup;
    }
    return false;
  }

  bool _isLastInGroup(int index, ReminderModel reminder) {
    if (index == widget.remindersList.length - 1) {
      return true;
    }
    if (index + 1 < widget.remindersList.length) {
      final prev = _groupBy(reminder).name;
      final currGroup = _groupBy(widget.remindersList[index + 1]).name;
      return prev != currGroup;
    }
    return false;
  }

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
      padding: const EdgeInsets.only(left: 24, top: 8.5, bottom: 8.5),
      color: context.designSystem.colors.backgroundListColor,
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      ),
    );
  }

  Group _groupBy(ReminderModel reminder) {
    final date = DateTime(
      reminder.dueDate.year,
      reminder.dueDate.month,
      reminder.dueDate.day,
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

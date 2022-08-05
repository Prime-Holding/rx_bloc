import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_progress_indicator.dart';
import '../../base/common_ui_components/app_reminder_tile.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../blocs/reminder_list_bloc.dart';
import 'scroll_to_index_widget.dart';

class ReminderListView extends StatefulWidget {
  const ReminderListView({
    this.createdReminderId,
    Key? key,
  }) : super(key: key);
  final String? createdReminderId;

  @override
  State<ReminderListView> createState() => _ReminderListViewState();
}

class _ReminderListViewState extends State<ReminderListView> {
  // late final AutoScrollController _controller;
  //
  // List<ReminderModel> remindersList = [];
  //
  // @override
  // void initState() {
  //   _controller = AutoScrollController();
  //   super.initState();
  // }
  //
  // @override
  // void didUpdateWidget(covariant ReminderListView oldWidget) {
  //   if (widget.createdReminderId != null &&
  //       oldWidget.createdReminderId != widget.createdReminderId) {
  //     final _correctIndex = remindersList
  //         .indexWhere((element) => element.id == widget.createdReminderId);
  //     print('correctIndex $_correctIndex');
  //
  //     _controller.scrollToIndex(
  //       _correctIndex,
  //       duration: const Duration(milliseconds: 50),
  //       preferPosition: AutoScrollPosition.middle,
  //     );
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }
  //
  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) => RxPaginatedBuilder<ReminderListBlocType,
          ReminderModel>.withRefreshIndicator(
        state: (bloc) {
          // remindersList = bloc.states.paginatedList;
          return bloc.states.paginatedList;
        },
        onBottomScrolled: (bloc) {
          print('onBottomScrolled');
          return bloc.events.loadPage();},
        onRefresh: (bloc) async {
          bloc.events.loadPage(reset: true);
          return bloc.states.refreshDone;
        },
        buildSuccess: (context, list, bloc) {
          // return _listViewBuilder(list);
          // remindersList = list.list;
          // if(list.isLoading){
          //   print('LISTISLOADING');
          //   return  const AppProgressIndicator();
          // }

          // if(list.isNextPageLoading){
          //   print('NEXTPAGE');
          //   return  const AppProgressIndicator();
          // }
          // print('SuccessList $list');

          return ReminderListScrollView(
            remindersList: list,
            scrollToReminderId: widget.createdReminderId,
          );
          // return _buildGroupedListView(context, list);
        },
        buildLoading: (context, list, bloc) {
          print('ReminderListViewLoading');
          return const AppProgressIndicator();
        },
        buildError: (context, list, bloc) => Container(),

  );

  ListView _listViewBuilder(PaginatedList<ReminderModel> list) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.itemCount,
      itemBuilder: (ctx, index) {
        var el = list.getItem(index);
        if(el == null){
          return const AppProgressIndicator();
        }
        return AppReminderTile(
          reminder: el,
          // isLast: index== (widget.remindersList.length - 1),
        );
      },
    );
  }

// GroupedListView<ReminderModel, Group> _buildGroupedListView(
//     BuildContext context, PaginatedList<ReminderModel> paginatedList) {
//   return GroupedListView<ReminderModel, Group>(
//     physics: const AlwaysScrollableScrollPhysics(),
//     controller: _controller,
//     keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//     useStickyGroupSeparators: true,
//     elements: paginatedList,
//     groupBy: _groupBy,
//     groupComparator: (value1, value2) => value1.index.compareTo(value2.index),
//     groupSeparatorBuilder: (Group type) {
//       var title = '';
//       if (type == Group.old) {
//         title = 'Old';
//       } else if (type == Group.today) {
//         title = 'Today';
//       } else if (type == Group.thisMonth) {
//         title = 'This month';
//       } else if (type == Group.thisYear) {
//         title = 'This year';
//       }
//
//       return Container(
//         width: double.infinity,
//         padding: const EdgeInsets.only(left: 24, top: 16),
//         color: context.designSystem.colors.secondaryColor,
//         child: Text(
//           title,
//           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
//         ),
//       );
//     },
//     indexedItemBuilder: (context, ReminderModel reminder, int index) {
//       // if (index == widget.remindersList.pageSize &&
//       //    while( widget.remindersList.isLoading && index == widget.remindersList.pageSize - 1) {
//       print('index $index');
//       // if((((paginatedList.pageSize % 10 ) -1 ) == index )&&  paginatedList.isLoading){
//       if(paginatedList.getItem(index) == null){
//       // if(paginatedList.isLoading){
//         print('LISTISLOADING');
//         return const AppProgressIndicator();
//       }
//       // if (index == paginatedList.pageSize - 1) {
//         // if (index == widget.remindersList.pageSize - 1) {
//         // print('LISTISLOADING');
//         // return const AppProgressIndicator();
//       // }
//       // if(widget.remindersList.isLoading){
//       //   print('LISTISLOADING');
//       //   return  const AppProgressIndicator();
//       // }
//       // if(widget.remindersList.getItem(index) == null){
//       //   print('GETItemIsNULL');
//       //   return const AppProgressIndicator();
//       // }
//       // print('reminder ISNULL ');
//       return _itemBuilder(index, reminder);
//     },
//   );
// }
//
// Container _itemBuilder(int index, ReminderModel reminder) {
//   return Container(
//     margin: const EdgeInsets.symmetric(
//       horizontal: 10,
//     ),
//     child: AutoScrollTag(
//       controller: _controller,
//       index: index,
//       key: ValueKey(index),
//       child: AppReminderTile(
//         reminder: reminder,
//         // isLast: index== (widget.remindersList.length - 1),
//       ),
//     ),
//   );
// }
//
// Group _groupBy(ReminderModel element) {
//   var date = DateTime(
//     element.dueDate.year,
//     element.dueDate.month,
//     element.dueDate.day,
//   );
//   var now = DateTime.now();
//   var today = DateTime(
//     now.year,
//     now.month,
//     now.day,
//   );
//   var isBeforeToday = date.isBefore(today);
//   var isToday = date.isAtSameMomentAs(today);
//
//   var thisYearMonth = DateTime(now.year, now.month, now.day);
//   var isThisMonth = date.month == now.month;
//   var isAfterThisMonth = date.isAfter(thisYearMonth);
//   Group groupTitle = Group.old;
//   if (isBeforeToday) {
//     groupTitle = Group.old;
//   } else if (isToday) {
//     groupTitle = Group.today;
//   } else if (isThisMonth) {
//     groupTitle = Group.thisMonth;
//   } else if (isAfterThisMonth) {
//     groupTitle = Group.thisYear;
//   }
//   return groupTitle;
// }
}

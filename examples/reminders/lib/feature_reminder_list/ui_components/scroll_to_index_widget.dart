import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:scroll_pos/scroll_pos.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_reminder_tile.dart';
import '../../base/common_ui_components/app_sticky_header.dart';
import '../../base/models/reminder/reminder_model.dart';

class ScrollPosWidget extends StatefulWidget {
  const ScrollPosWidget(this.list, this.id, {Key? key}) : super(key: key);

  final PaginatedList<ReminderModel> list;
  final String id;

  @override
  State<ScrollPosWidget> createState() => _ScrollPosWidgetState();
}

class _ScrollPosWidgetState extends State<ScrollPosWidget> {
  late final ScrollPosController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = ScrollPosController(itemCount: widget.list.length);
    final _correctIndex =
        widget.list.indexWhere((element) => element.id == widget.id);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
        _scrollToIndex(_correctIndex);
    });
    super.initState();
  }

  void _scrollToIndex(int i) {
    if (i != 0) {
      _controller.scrollToItem(i, center: true);
    }
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
                reminder: widget.list.list[i],
                isLast: i == (widget.list.length - 1),
                key: ValueKey(i),
              ),
              childCount: widget.list.list.length,
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

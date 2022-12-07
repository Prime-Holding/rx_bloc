import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../app_extensions.dart';
import '../models/reminder/reminder_model.dart';
import 'app_divider.dart';

class AppReminderTile extends StatefulWidget {
  const AppReminderTile({
    required this.reminder,
    this.onTitleChanged,
    this.onDueDateChanged,
    this.onCompleteChanged,
    this.onDeletePressed,
    this.isFirst = false,
    this.isLast = false,
    Key? key,
  }) : super(key: key);

  final ReminderModel reminder;
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<DateTime>? onDueDateChanged;
  final ValueChanged<bool>? onCompleteChanged;
  final VoidCallback? onDeletePressed;
  final bool isFirst;
  final bool isLast;

  @override
  State<AppReminderTile> createState() => _AppReminderTileState();
}

class _AppReminderTileState extends State<AppReminderTile> {
  late final TextEditingController _textEditingController;
  late final FocusNode _titleFocusNode = FocusNode();

  String get dueDate => _formatter.format(widget.reminder.dueDate);

  final _formatter = DateFormat.yMd();

  @override
  void didUpdateWidget(covariant AppReminderTile oldWidget) {
    if (widget.reminder.title != oldWidget.reminder.title) {
      _textEditingController.text = widget.reminder.title;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.reminder.title);
    _titleFocusNode.addListener(
      () {
        if (!_titleFocusNode.hasFocus) {
          widget.onTitleChanged?.call(_textEditingController.text);
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: context.designSystem.colors.secondaryColor,
          borderRadius: _getRadius(),
        ),
        child: Slidable(
            key: Key('Reminder${widget.reminder.id}'),
            startActionPane: _buildActionPane(context),
            endActionPane: _buildActionPane(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  if (widget.isFirst) const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: widget.reminder.complete
                            ? Icon(Icons.radio_button_checked,
                                color: Colors.blue.shade700)
                            : const Icon(Icons.radio_button_off,
                                color: Colors.grey),
                        onPressed: () => widget.onCompleteChanged
                            ?.call(!widget.reminder.complete),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _titleFocusNode,
                          textInputAction: TextInputAction.done,
                          controller: _textEditingController,
                          minLines: 1,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _onDueDatePressed,
                        child: Text(dueDate),
                      ),
                    ],
                  ),
                  !widget.isLast
                      ? const AppDivider()
                      : const SizedBox(height: 8),
                ],
              ),
            )),
      );

  BorderRadiusGeometry? _getRadius() {
    if (widget.isFirst || widget.isLast) {
      return BorderRadius.only(
        topLeft: Radius.circular(widget.isFirst ? 20 : 0),
        topRight: Radius.circular(widget.isFirst ? 20 : 0),
        bottomRight: Radius.circular(widget.isLast ? 20 : 0),
        bottomLeft: Radius.circular(widget.isLast ? 20 : 0),
      );
    }

    return null;
  }

  ActionPane _buildActionPane(BuildContext context) => ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => widget.onDeletePressed?.call(),
            backgroundColor:
                context.designSystem.colors.inputDecorationErrorLabelColor,
            foregroundColor: context.designSystem.colors.canvasColor,
            icon: Icons.delete,
            label: context.l10n.delete,
          ),
        ],
      );

  Future<void> _onDueDatePressed() async {
    var date = await showDatePicker(
      context: context,
      initialDate: widget.reminder.dueDate,
      firstDate: DateTime.now().subtract(
        const Duration(days: 365),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );
    final now = DateTime.now();
    date = date?.add(Duration(
        hours: now.hour,
        minutes: now.minute,
        seconds: now.second,
        milliseconds: now.millisecond,
        microseconds: now.microsecond));
    if (date != null && mounted) {
      widget.onDueDateChanged?.call(date);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../app_extensions.dart';
import '../../feature_reminder_manage/blocs/reminder_manage_bloc.dart';
import '../models/reminder/reminder_model.dart';
import 'app_divider.dart';

class AppReminderTile extends StatefulWidget {
  const AppReminderTile({
    required this.reminder,
    this.onTitleChanged,
    this.onDueDateChanged,
    this.isFirst = false,
    this.isLast = false,
    Key? key,
  }) : super(key: key);

  final ReminderModel reminder;
  final Function(String)? onTitleChanged;
  final Function(DateTime)? onDueDateChanged;
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
          context
              .read<ReminderManageBlocType>()
              .events
              .update(widget.reminder.copyWith(
                title: _textEditingController.text,
                completeUpdated: false,
              ));

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
  Widget build(BuildContext context) => Slidable(
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
            !widget.isLast ? const AppDivider() : const SizedBox(height: 8),
          ],
        ),
      ));

  ActionPane _buildActionPane(BuildContext context) => ActionPane(
        extentRatio: 0.7,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) =>
                context.read<ReminderManageBlocType>().events.update(
                      widget.reminder.copyWith(
                        complete: !widget.reminder.complete,
                        completeUpdated: true,
                      ),
                    ),
            backgroundColor: widget.reminder.complete
                ? context.designSystem.colors.actionButtonCompleteColor
                : context.designSystem.colors.actionButtonInCompleteColor,
            foregroundColor: context.designSystem.colors.canvasColor,
            icon: Icons.check_box_outlined,
            label: widget.reminder.complete
                ? context.l10n.incomplete
                : context.l10n.complete,
          ),
          SlidableAction(
            onPressed: null,
            backgroundColor: context.designSystem.colors.activeButtonColor,
            foregroundColor: context.designSystem.colors.canvasColor,
            icon: Icons.edit,
            label: context.l10n.edit,
          ),
          SlidableAction(
            onPressed: (context) => context
                .read<ReminderManageBlocType>()
                .events
                .delete(widget.reminder),
            backgroundColor:
                context.designSystem.colors.inputDecorationErrorLabelColor,
            foregroundColor: context.designSystem.colors.canvasColor,
            icon: Icons.delete,
            label: context.l10n.delete,
          ),
        ],
      );

  Future<void> _onDueDatePressed() async {
    final date = await showDatePicker(
      context: context,
      initialDate: widget.reminder.dueDate,
      firstDate: DateTime.now().subtract(
        const Duration(days: 365),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date != null) {
      context
          .read<ReminderManageBlocType>()
          .events
          .update(widget.reminder.copyWith(
            dueDate: date,
            completeUpdated: false,
          ));

      widget.onDueDateChanged?.call(date);
    }
  }
}

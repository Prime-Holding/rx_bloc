import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../app_extensions.dart';
import '../../feature_reminder_manage/blocs/reminder_manage_bloc.dart';

class AddReminderDialog extends StatefulWidget {
  const AddReminderDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddReminderDialogState();
}

class AddReminderDialogState extends State<AddReminderDialog> {
  late TextEditingController _textEditingController;

  late final FocusNode _titleFocusNode = FocusNode();

  DateTime dueDate = DateTime.now();

  final _formatter = DateFormat.yMd();

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Add Reminder'),
        content: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.name),
                  TextField(
                    focusNode: _titleFocusNode,
                    textInputAction: TextInputAction.done,
                    controller: _textEditingController,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.date),
                TextButton(
                  onPressed: _onDueDatePressed,
                  child: Text(_formatter.format(dueDate)),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              context.read<ReminderManageBlocType>().events.create(
                    complete: false,
                    dueDate: dueDate,
                    title: _textEditingController.text,
                    completeUpdated: false,
                  );
              Navigator.of(context).pop();
            },
          )
        ],
      );

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _onDueDatePressed() async {
    final date = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime.now().subtract(
        const Duration(days: 365),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date != null) {
      setState(() {
        dueDate = date;
      });
    }
  }
}

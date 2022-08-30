import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import '../../app_extensions.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../feature_reminder_manage/blocs/reminder_manage_bloc.dart';
import '../ui_components/simple_text_field.dart';

class AddReminderDialog extends StatefulWidget {
  const AddReminderDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddReminderDialogState();
}

class AddReminderDialogState extends State<AddReminderDialog> {
  late TextEditingController _textEditingController;

  DateTime dueDate = DateTime.now();

  final _formatter = DateFormat.yMd();

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  Widget _creationListener() =>
      RxBlocListener<ReminderManageBlocType, Result<ReminderModel>>(
        state: (bloc) => bloc.states.onCreated,
        listener: (context, onCreated) {
          if (onCreated != null && onCreated is ResultSuccess) {
            Navigator.of(context).pop();
          }
        },
      );

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Add Reminder'),
        content: Row(
          children: [
            _creationListener(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.name),
                  _buildName(),
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
              context.read<ReminderManageBlocType>().events
                ..validate()
                ..create(
                  complete: false,
                  dueDate: dueDate,
                );
            },
          )
        ],
      );

  Widget _buildName() => RxBlocBuilder<ReminderManageBlocType, String?>(
        state: (bloc) => bloc.states.nameErrorMessage,
        builder: (context, state, bloc) => SimpleTextField(
          key: const ValueKey('name'),
          onChanged: bloc.events.setName,
          errorText: state.data,
          text: bloc.states.name,
          errorMaxLines: 2,
        ),
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

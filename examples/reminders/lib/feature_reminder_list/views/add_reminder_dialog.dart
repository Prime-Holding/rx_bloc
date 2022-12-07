import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../app_extensions.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../feature_reminder_manage/blocs/reminder_manage_bloc.dart';

class AddReminderDialog extends StatefulWidget {
  const AddReminderDialog({super.key});

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

  InputDecoration _buildTextFieldDecoration(BuildContext context) =>
      InputDecoration(
        errorMaxLines: 2,
        errorStyle: TextStyle(
          color: context.designSystem.colors.inputDecorationErrorLabelColor,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 12,
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: context.designSystem.colors.inputDecorationErrorLabelColor,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: context.designSystem.colors.inputDecorationErrorLabelColor,
          ),
        ),
      );

  Widget _creationListener() =>
      RxBlocListener<ReminderManageBlocType, Result<ReminderModel>>(
        state: (bloc) => bloc.states.onCreated,
        listener: (context, onCreated) {
          if (onCreated is ResultSuccess) {
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
                  _buildNameField(),
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
                  );
            },
          ),
        ],
      );

  Widget _buildNameField() => RxTextFormFieldBuilder<ReminderManageBlocType>(
        state: (bloc) => bloc.states.name,
        showErrorState: (bloc) => bloc.states.showErrors,
        onChanged: (bloc, value) => bloc.events.setName(value),
        builder: (fieldState) => TextFormField(
          key: const ValueKey('ReminderNameInputField'),
          cursorColor: const Color(0xff333333),
          maxLines: 1,
          textInputAction: TextInputAction.next,
          controller: fieldState.controller,
          decoration: fieldState.decoration
              .copyWithDecoration(_buildTextFieldDecoration(context)),
        ),
      );

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

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

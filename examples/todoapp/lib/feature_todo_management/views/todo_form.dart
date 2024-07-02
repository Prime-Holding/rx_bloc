import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/rx_form.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../blocs/todo_management_bloc.dart';

class TodoForm extends StatelessWidget {
  const TodoForm({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          RxTextFormFieldBuilder<TodoManagementBlocType>(
            state: (bloc) => bloc.states.title.translate(context),
            showErrorState: (bloc) => bloc.states.showError,
            onChanged: (bloc, title) => bloc.events.setTitle(title),
            cursorBehaviour: RxTextFormFieldCursorBehaviour.end,
            builder: (fieldState) => TextFormField(
              controller: fieldState.controller,
              style: context.designSystem.typography.h3Med14,
              decoration: fieldState.decoration.copyWith(
                  border: const UnderlineInputBorder(),
                  hintText: context.l10n.whatToDo),
            ),
          ),
          SizedBox(
            height: context.designSystem.spacing.l,
          ),
          Expanded(
            child: RxTextFormFieldBuilder<TodoManagementBlocType>(
              state: (bloc) => bloc.states.description.translate(context),
              showErrorState: (bloc) => bloc.states.showError,
              onChanged: (bloc, description) =>
                  bloc.events.setDescription(description),
              builder: (fieldState) => TextFormField(
                controller: fieldState.controller,
                style: context.designSystem.typography.h3Med13,
                minLines: 1,
                maxLines: 5,
                decoration: fieldState.decoration.copyWith(
                  border: const UnderlineInputBorder(),
                  hintText: context.l10n.additionalNotes,
                ),
              ),
            ),
          ),
          AppErrorModalWidget<TodoManagementBlocType>(
            errorState: (bloc) => bloc.states.errors,
          ),
        ],
      );
}

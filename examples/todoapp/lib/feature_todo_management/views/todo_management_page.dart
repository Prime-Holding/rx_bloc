import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_bar_title.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../blocs/todo_management_bloc.dart';

class TodoManagementPage extends StatefulWidget {
  const TodoManagementPage({
    super.key,
  });

  @override
  State<TodoManagementPage> createState() => _TodoManagementPageState();
}

class _TodoManagementPageState extends State<TodoManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
            title: context.read<TodoManagementBlocType>().states.isEditingTodo
                ? context.l10n.editTodo
                : context.l10n.addTodo),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: context.designSystem.spacing.s1,
            horizontal: context.designSystem.spacing.xl),
        child: Column(
          children: <Widget>[
            RxTextFormFieldBuilder<TodoManagementBlocType>(
              state: (bloc) => bloc.states.title.translate(context),
              showErrorState: (bloc) => bloc.states.showError,
              onChanged: (bloc, title) => bloc.events.setTitle(title),
              cursorBehaviour: RxTextFormFieldCursorBehaviour.end,
              builder: (fieldState) => TextFormField(
                controller: fieldState.controller,
                style: context.designSystem.typography.h3Med13,
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
                  style: context.designSystem.typography.h2Med16,
                  // minLines: 1,
                  // maxLines: 5,
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
        ),
      ),
      floatingActionButton: RxBlocBuilder<TodoManagementBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, isLoadingSnapshot, bloc) => Visibility(
          visible: isLoadingSnapshot.data == null || !isLoadingSnapshot.data!,
          child: FloatingActionButton(
            key: const Key('edit_todo_fab'),
            onPressed: () =>
                context.read<TodoManagementBlocType>().events.save(),
            shape: const OvalBorder(),
            child: context.read<TodoManagementBlocType>().states.isEditingTodo
                ? context.designSystem.icons.updateConfirm
                : context.designSystem.icons.add,
          ),
        ),
      ),
    );
  }
}

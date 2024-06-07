import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_bar_title.dart';
import '../blocs/todo_management_bloc.dart';
import 'todo_form.dart';

class TodoManagementPage extends StatelessWidget {
  const TodoManagementPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: AppBarTitle(
            title: context.read<TodoManagementBlocType>().states.isEditingTodo
                ? context.l10n.editTodo
                : context.l10n.addTodo,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.designSystem.spacing.s1,
            horizontal: context.designSystem.spacing.xl,
          ),
          child: const TodoForm(),
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

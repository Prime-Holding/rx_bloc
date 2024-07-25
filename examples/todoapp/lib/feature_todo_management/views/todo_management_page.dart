import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_bar_title.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';
import '../blocs/todo_management_bloc.dart';
import 'todo_form.dart';

class TodoManagementPage extends StatelessWidget {
  const TodoManagementPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      RxBlocBuilder<TodoManagementBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, isLoadingSnapshot, bloc) {
          final isLoading =
              (isLoadingSnapshot.hasData && isLoadingSnapshot.requireData);
          return Scaffold(
            appBar: AppBar(
              title: AppBarTitle(
                title:
                    context.read<TodoManagementBlocType>().states.isEditingTodo
                        ? context.l10n.editTodo
                        : context.l10n.addTodo,
              ),
              leading: IconButton(
                icon: context.designSystem.icons.close,
                onPressed: isLoading ? null : () => context.pop(),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.designSystem.spacing.s1,
                horizontal: context.designSystem.spacing.xl,
              ),
              child: TodoForm(isLoading: isLoading),
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'fab',
              onPressed: isLoading
                  ? null
                  : () => context.read<TodoManagementBlocType>().events.save(),
              shape: const OvalBorder(),
              child: isLoading
                  ? AppLoadingIndicator.textButtonValue(context)
                  : context.read<TodoManagementBlocType>().states.isEditingTodo
                      ? context.designSystem.icons.updateConfirm
                      : context.designSystem.icons.add,
            ),
          );
        },
      );
}

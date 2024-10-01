import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_bar_title.dart';
import '../../base/common_ui_components/app_error_widget.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';
import '../../base/common_ui_components/todo_widget.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/todo_model.dart';
import '../../lib_todo_actions/blocs/todo_actions_bloc.dart';
import '../blocs/todo_details_bloc.dart';

class TodoDetailsPage extends StatelessWidget {
  const TodoDetailsPage({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: AppBarTitle(title: context.l10n.todoDetails),
          actions: [
            RxBlocBuilder<TodoActionsBlocType, bool>(
              state: (bloc) => bloc.states.isLoading,
              builder: (context, isLoadingSnapshot, bloc) => SmallButton(
                key: K.todoDetailsPageDeleteButton,
                type: SmallButtonType.icon,
                colorStyle: ButtonColorStyle.fromContext(context),
                onPressed: () =>
                    context.read<TodoActionsBlocType>().events.delete(id),
                icon: context.designSystem.icons.delete.icon,
                state: isLoadingSnapshot.buttonStateModel,
              ),
            ),
          ],
        ),
        floatingActionButton: RxBlocBuilder<TodoDetailsBlocType, bool>(
          state: (bloc) => bloc.states.isLoading,
          builder: (context, isLoadingSnapshot, bloc) => FloatingActionButton(
            key: K.todoDetailsPageEditButton,
            heroTag: 'fab',
            onPressed: bloc.events.updateTodo,
            shape: const OvalBorder(),
            child: context.designSystem.icons.edit,
          ),
        ),
        body: Column(
          children: [
            RxResultBuilder<TodoDetailsBlocType, $TodoModel>(
              state: (bloc) => bloc.states.todo,
              buildSuccess: (context, todo, bloc) =>
                  RxBlocBuilder<TodoActionsBlocType, bool>(
                state: (bloc) => bloc.states.isLoading,
                builder: (context, isLoadingSnapshot, bloc) => TodoWidget(
                  todo: todo,
                  onChanged: (!isLoadingSnapshot.hasData ||
                          isLoadingSnapshot.requireData)
                      ? null
                      : (todo, isChecked) {
                          final todoId = todo.id;
                          if (todoId != null) {
                            context
                                .read<TodoActionsBlocType>()
                                .events
                                .updateCompletedById(todo.id!, isChecked!);
                          }
                        },
                ),
              ),
              buildError: (context, error, bloc) => Padding(
                padding: EdgeInsets.only(top: context.designSystem.spacing.l),
                child: Center(
                  child: AppErrorWidget(
                    error: error.asErrorModel(),
                    onTabRetry: () => bloc.events.fetchTodo(),
                  ),
                ),
              ),
              buildLoading: (context, bloc) =>
                  const Center(child: AppLoadingIndicator()),
            ),
          ],
        ),
      );
}

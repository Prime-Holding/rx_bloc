import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import '../blocs/todo_list_bulk_edit_bloc.dart';
import '../services/todo_actions_service.dart';
import '../ui_components/app_todo_list_bulk_edit_popup_menu_button.dart';

class AppTodoListBulkEditPopupMenuButtonWithDependencies
    extends StatelessWidget {
  const AppTodoListBulkEditPopupMenuButtonWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._blocs,
        ],
        child: const AppTodoListBulkEditPopupMenuButton(),
      );

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<TodoListBulkEditBlocType>(
          create: (context) => TodoListBulkEditBloc(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
}

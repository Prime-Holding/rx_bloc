import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../lib_todo_actions/blocs/todo_list_bulk_edit_bloc.dart';
import '../blocs/todo_list_bloc.dart';
import '../views/todo_list_page.dart';

class TodoListPageWithDependencies extends StatelessWidget {
  const TodoListPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._blocs,
        ],
        child: const TodoListPage(),
      );

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<TodoListBlocType>(
          create: (context) => TodoListBloc(
            context.read(),
            context.read(),
          ),
        ),
        RxBlocProvider<TodoListBulkEditBlocType>(
          create: (context) => TodoListBulkEditBloc(
            context.read(),
            context.read(),
          ),
        ),
      ];
}

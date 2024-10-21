import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/models/todo_model.dart';
import '../blocs/todo_details_bloc.dart';

import '../views/todo_details_page.dart';

class TodoDetailsPageWithDependencies extends StatelessWidget {
  const TodoDetailsPageWithDependencies({
    super.key,
    required this.todoModel,
    required this.todoId,
  });

  final $TodoModel? todoModel;
  final String todoId;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._blocs,
        ],
        child: TodoDetailsPage(
          id: todoId,
        ),
      );

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<TodoDetailsBlocType>(
          create: (context) => TodoDetailsBloc(
            todoId,
            todoModel,
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
}

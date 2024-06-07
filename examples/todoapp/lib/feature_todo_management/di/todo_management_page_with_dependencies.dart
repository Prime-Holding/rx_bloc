import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/models/todo_model.dart';
import '../blocs/todo_management_bloc.dart';
import '../services/todo_management_service.dart';
import '../services/todo_validator_service.dart';
import '../views/todo_management_page.dart';

class TodoManagementPageWithDependencies extends StatelessWidget {
  const TodoManagementPageWithDependencies({
    super.key,
    this.id,
    this.initialTodo,
  });

  /// The id of the todo.
  /// If the id is not null, the todo is being edited otherwise it is being created.
  final String? id;

  /// The todo model. If the todo is being edited, the model is fetched from the server.
  final TodoModel? initialTodo;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const TodoManagementPage(),
      );

  List<Provider> get _services => [
        Provider<TodoManagementService>(
          create: (context) => TodoManagementService(
            context.read(),
          ),
        ),
        Provider<TodoValidatorService>(
          create: (context) => TodoValidatorService(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<TodoManagementBlocType>(
          create: (context) => TodoManagementBloc(
            id,
            initialTodo,
            context.read(),
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
}

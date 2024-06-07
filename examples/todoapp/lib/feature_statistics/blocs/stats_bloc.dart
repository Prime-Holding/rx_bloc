import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../models/todo_stats_model.dart';
import '../services/stats_service.dart';

part 'stats_bloc.rxb.g.dart';

abstract class StatsBlocEvents {}

/// A contract class containing all states of the StatsBloC.
abstract class StatsBlocStates {
  /// The statistics of the todos.
  ///
  /// This state will be updated whenever the statistics of the todos change.
  Stream<TodoStatsModel> get todosStats;
}

@RxBloc()
class StatsBloc extends $StatsBloc {
  StatsBloc(this._coordinatorBloc, this._service);

  final StatsService _service;
  final CoordinatorBlocType _coordinatorBloc;

  @override
  Stream<TodoStatsModel> _mapToTodosStatsState() =>
      _coordinatorBloc.states.onTodoListChanged
          .whereSuccess()
          .map((todoList) => _service.calculateStats(todoList));
}

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/feature_todo_details/blocs/todo_details_bloc.dart';

import 'todo_details_mock.mocks.dart';

@GenerateMocks(
    [TodoDetailsBlocStates, TodoDetailsBlocEvents, TodoDetailsBlocType])
TodoDetailsBlocType todoDetailsMockFactory({
  bool? isLoading,
  ErrorModel? errors,
  Result<$TodoModel>? todo,
}) {
  final blocMock = MockTodoDetailsBlocType();
  final eventsMock = MockTodoDetailsBlocEvents();
  final statesMock = MockTodoDetailsBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<ErrorModel>.empty();

  final todoState = (todo != null
          ? Stream.value(todo)
          : const Stream<Result<$TodoModel>>.empty())
      .publishReplay(maxSize: 1)
    ..connect();
  final onRoutingState = const Stream<void>.empty().publishReplay(maxSize: 1)
    ..connect();

  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.errors).thenAnswer((_) => errorsState);
  when(statesMock.todo).thenAnswer((_) => todoState);
  when(statesMock.onRouting).thenAnswer((_) => onRoutingState);

  return blocMock;
}

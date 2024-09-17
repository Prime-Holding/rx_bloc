import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todoapp/assets.dart';
import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/base/models/todo_model.dart';
import 'package:todoapp/feature_todo_management/blocs/todo_management_bloc.dart';

import 'todo_management_mock.mocks.dart';

@GenerateMocks([
  TodoManagementBlocStates,
  TodoManagementBlocEvents,
  TodoManagementBlocType
])
TodoManagementBlocType todoManagementMockFactory({
  String? title,
  String? description,
  bool? showError,
  bool? isLoading,
  ErrorModel? errors,
  $TodoModel? onTodoSaved,
}) {
  final blocMock = MockTodoManagementBlocType();
  final eventsMock = MockTodoManagementBlocEvents();
  final statesMock = MockTodoManagementBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final titleState = title != null
      ? showError != null && showError == true
          ? Stream<String>.error(FieldErrorModel(
              errorKey: I18nErrorKeys.tooShort,
              fieldValue: title,
            )).shareReplay(maxSize: 1)
          : Stream.value(title).shareReplay(maxSize: 1)
      : const Stream<String>.empty();

  final descriptionState = description != null
      ? Stream.value(description).shareReplay(maxSize: 1)
      : const Stream<String>.empty();

  final showErrorState = showError != null
      ? Stream.value(showError).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<ErrorModel>.empty();

  final onTodoSavedState = (onTodoSaved != null
          ? Stream.value(onTodoSaved)
          : const Stream<TodoModel>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final isEditingTodo = title != null;

  when(statesMock.isEditingTodo).thenAnswer((_) => isEditingTodo);

  when(statesMock.title).thenAnswer((_) => titleState);
  when(statesMock.description).thenAnswer((_) => descriptionState);
  when(statesMock.showError).thenAnswer((_) => showErrorState);
  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.errors).thenAnswer((_) => errorsState);
  when(statesMock.onTodoSaved).thenAnswer((_) => onTodoSavedState);

  return blocMock;
}

### Overview
This application manages a list of todos, allowing users to create, update, and delete tasks. 
One of the key features of the application is the ability to synchronize todos with a remote server to ensure data consistency.

## Synchronization of Todos
The synchronization process is handled by the synchronizeTodos function. This function ensures that any todos that have not yet been synced with the remote server are uploaded, and the local database is updated accordingly. Additionally, synchronization is triggered when the user's internet connectivity state changes.

```dart
class TodoListService {
  TodoListService(
    this._repository,
    this._connectivityRepository,
  ) {
    _connectivitySubscription =
        _connectivityRepository.connected().listen((event) {
      if (event) {
        synchronizeTodos();
      }
    });
  }
  final TodoRepository _repository;
  final ConnectivityRepository _connectivityRepository;
  StreamSubscription<bool>? _connectivitySubscription;

  Future<void> synchronizeTodos() async {
    final List<$TodoModel> unsyncedTodos =
        await _repository.fetchAllUnsyncedTodos();
    if (unsyncedTodos.isNotEmpty) {
      final result = await _repository.syncTodos({'todos': unsyncedTodos});
      _repository.deleteMany(unsyncedTodos);
      _repository.addMany(result);
    }
  }
  ...
}
```

The constructor initializes the TodoListService with a TodoRepository and a ConnectivityRepository.
It subscribes to the connectivity status changes using _connectivityRepository.connected().listen((event) { ... }).
When the connectivity status changes to connected (event is true), it triggers the synchronizeTodos function.


## Todo management

The Todo repository manages all operations on todos, and all operations follow a consistent approach: if a request to the remote server fails, the changes are saved locally. This ensures data integrity and allows for subsequent retries or recovery.

For instance, the deleteTodoById function manages the deletion of todos. It first attempts to delete a todo from the remote server and then from the local database. If the remote deletion fails, the function gracefully handles the error by performing a soft delete locally. This approach marks the todo as deleted without actually removing it from the local database, facilitating future recovery or retry attempts.

```dart
Future<void> deleteTodoById(String id) => _errorMapper.execute(
        () async {
          await dataSource.deleteTodoById(id);
          localDataSource.deleteTodoById(id);
        },
      ).onError(
        (error, stackTrace) {
          handleError(
            error,
            localDataSource.softDeleteTodoById(
              id,
              synced: false,
              action: TodoModelActions.delete.name,
            ),
          );
        },
      );
```

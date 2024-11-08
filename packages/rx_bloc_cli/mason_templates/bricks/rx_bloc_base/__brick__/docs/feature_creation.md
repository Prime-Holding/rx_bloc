## Manual Feature Creation

This documentation covers the manual steps needed for setting up a feature. Many steps mentioned in this document can be automated by using the [RxBloc intelliJ plugin](https://plugins.jetbrains.com/plugin/16165-rxbloc).

### Steps
1. [Feature directory](#feature-directory)
2. [Feature directory structure](#feature-directory-structure)
3. [Views](#views)
4. [Dependency Injection (DI)](#dependency-injection-di)
5. [Blocs](#blocs)
6. [Services](#services)
7. [Go route](#go-route)
8. [Routes Path](#routes-path)
9. [Route Permissions](#route-permissions)
10. [Route Model](#route-model)



## Feature directory

All new features should be created in the `lib` directory. Each new feature name should start with a prefix `feature_` and should be in the snake case. For example, if you are creating a feature called `counter`, the feature directory should be named `feature_counter`. 

### Feature directory structure
```
├──lib
│ ├── feature_counter
│ │ ├── blocs
│ │ ├── di
│ │ ├── services
│ │ └── views
```
### Views

All views should be created in the `views` sub-directory of the feature. Generally, each  `view` represents a screen in the application. A single feature can have multiple views.

Views are created either as a `StatelessWidget` or a `StatefulWidget`. The view can listen to the blocs to update the UI and can send events to the blocs to update the state. Widgets like `RxBlocBuilder` and `RxBlocListener` can be used to react and manipulate the bloc data.

### Dependency Injection (DI)

The `di` sub-directory of the feature contains the dependency injection code for the feature. It's created either as a `StatefullWidget` or a `StatelessWidget`. The `di` widget is responsible for providing the dependencies to the views. The widget should follow the naming convention `FeatureViewNameWithDependencies`. For the `counter` feature, since the `view` earlier created is named `CounterPage`, the `di` widget should be named `CounterPageWithDependencies`.

Unlike the app-wide `di`, feature specific `di` automatically manages the lifecycle of their dependencies removing them from the widget tree when the user is not accessing the underlying views.

The `di` widget build method returns a `MultiProvider` that wraps a child property with a list of providers, each responsible for providing a specific dependency. The `MultiProvider` has a child property that is an instance of the `view` created earlier.

Example
```dart

class CounterPageWithDependencies extends StatelessWidget {
  const CounterPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const CounterPage(),
      );

  List<Provider> get _services => [
        Provider<CounterService>(
          create: (context) => CounterService(
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<CounterBlocType>(
          create: (context) => CounterBloc(
            context.read(),
          ),
        ),
      ];
}
```



### Blocs

All blocs should be created in the `bloc` sub-directory of the feature. Blocs are used to manage the state of the application. A single feature can have multiple blocs. Blocs can be listened to by the views to update the UI, and the view can send events to the blocs to update the state.

Each `bloc` is made up of three parts:

1. `Events`: Events are pure methods created in an abstract class that represent the actions that can be performed on the bloc.
2. `States`: States are streams that represent the state of the bloc. States are declared in a single abstract class.
3. `Bloc`: The bloc class is created by extending the generated bloc class. The bloc class is responsible for mapping the events to the states. The bloc class must be annotated with `@RxBloc()` annotation in order to generate the boilerplate class that is extended by the bloc class.


```dart
abstract class CounterBlocEvents {
  void increment();

  void decrement();
}

abstract class CounterBlocStates {

  Stream<LoadingWithTag> get isLoading;

  Stream<ErrorModel> get errors;

  Stream<int> get count;
}

@RxBloc()
class CounterBloc extends $CounterBloc {
  CounterBloc(this._service);

  final CounterService _service;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<LoadingWithTag> _mapToIsLoadingState() => loadingWithTagState;

  @override
  Stream<int> _mapToCountState() => Rx.merge<Result<Count>>([
        // On increment.
        _$incrementEvent.switchMap(
            (_) => _service.increment().asResultStream(tag: tagIncrement)),
        // On decrement.
        _$decrementEvent.switchMap(
            (_) => _service.decrement().asResultStream(tag: tagDecrement)),
      ])
          .setResultStateHandler(this)
          .whereSuccess()
          .map((event) => event.value)
          .shareReplay(maxSize: 1);
}
```

### Services

All services should be created in the `services` sub-directory of the feature. Each service should follow the naming convention `feature_name_service.dart`. For example, if you are creating a service for the feature `counter`, the service should be named `counter_service.dart`. Services are used to interact with the repository layer of the application and provide data to the blocs. Services can only communicate with the repository layer and should contain business logic.

Services are created as dart classes and the class should follow the naming convention `FeatureNameService`. For the `counter` feature, the service class should be named `CounterService`. Services can depend on multiple repositories and each repository should be a private field in the service class starting with an underscore `_`, so that it is not accessible outside the class. 

```dart
class CounterService {
  CounterService(this._counterRepository);
  final CounterRepository _counterRepository;

  int getCounter() =>
     _counterRepository.getCounter();

  void incrementCounter() {
        _counterRepository.incrementCounter();
  }
}
```

## Routes

### Go route
 
In order to utilize `GoRouter` navigation in the application, the feature has to be added to the `router.dart` file. All of the routes in the application are defined inside the `lib_router/routes` directory, depending on the type of the route it can be placed in the corresponding file that is appropriate for the route type. Each of the files in `lib_router/routes` is a `part of '../router.dart'` file.

In order to utilize type safety each route is annotated with `@TypedGoRoute` annotation, which with the use of `go_router_builder` generates a strongly typed route.

Example of a `GoRoute` for the `counter` feature:

```dart
@TypedGoRoute<CounterRoute>(path: RoutesPath.counter)
@immutable
class CounterRoute extends GoRouteData implements RouteDataModel {
  const CounterRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const CounterPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.counter.permissionName;

  @override
  String get routeLocation => location;
}
```


### Routes Path

`RoutesPath` class is used to define statically typed routes in the application.
Each new feature that is going to be used in combination with the `GoRouter` has to have its path added to the `RoutesPath` class. All paths should be `static const String`.

### Route Permissions

`RoutePermissions` class is used to define the statically typed permission identifier, which in combination with the backend can be used for access restrictions. Each new feature that is going to be used in combination with the `GoRouter` has to have its permission added to the `RoutePermissions` class. All permissions should be `static const String`.


### Route Model
`RouteModel` is a enhanced enum that is used to define the route model, it is made of the following properties: `pathName`, `fullPath`, `permissionName`. Each feature has to have a corresponding enhanced enum declared.

Example for the `counter` feature:
```dart
  counter(
    pathName: RoutesPath.counter,
    fullPath: '/counter',
    permissionName: RoutePermissions.counter,
  ),
```

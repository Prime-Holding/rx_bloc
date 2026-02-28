---
description: Create a new feature in the todoapp project.
---

# Create a New Feature Skill

This skill guides the Agentic Development Environment (e.g., Cursor, Antigravity) in creating a new feature in the `todoapp` project, adhering strictly to the established architecture and structure.

## Inputs Required

To successfully execute this skill, the following inputs MUST be provided:
1. **Figma Link (using MCP):** The design file containing the UI layout, colors, typography, and intended interactions for the new feature.
2. **Swagger (Open API) Specification:** The API documentation defining the needed API endpoints, request models, and response models.

## Project Structure & Architecture

The application uses the **RxBloc** pattern for state management, **GoRouter** for navigation, and a centralized dependency injection system. A rigorous directory hierarchy rules where logic should be placed. Always refer to the following structure map before creating or modifying files:

### Application-Specific Classes
These files govern the root behavior, themes, routing, and shared dependencies of the entire app:
- `lib/base/app`: The root widget used in application entry points.
- `lib/base/app/config`: Environment-specific configurations and constants.
- `lib/base/app/initialization`: Core initializations like Firebase, Push Notifications, etc.
- `lib/base/data_sources/local`: Scoped local data sources (Shared Preferences, Secure Storage).
- `lib/base/data_sources/remote`: Remote data sources (APIs). **Retrofit code lives here.**
- `lib/base/theme/design_system`: Central design catalog for colors, typography, images, and spacing.
- `lib/base/common_mappers`: Application-wide mappers converting DTOs to business models (e.g., ErrorMapper).
- `lib/base/common_ui_components`: Reusable application-wide widgets (buttons, controls, text fields).
- `lib/base/common_blocs`: Generic purpose BLoCs shared globally (e.g., `CoordinatorBloc`).
- `lib/base/common_services`: Shared service classes (e.g., `TodoListService`).
- `lib/base/repositories`: Repository classes handling generalized endpoints.
- `lib/base/models`: Foundation DTOs and business models.
- `lib/base/di`: Centralized DI providers for global instances.

### Application-Specific Libraries
These handle core technical mechanics disconnected from UI features.
- `lib/lib_auth`: OAuth2 token management logic.
- `lib/lib_permissions`: ACL (Access Control List) logic guarding route access.
- `lib/lib_router`: Core navigation handling (`RouterBloc` and GoRouter instances).
- `lib/lib_router/routes`: Declarations for mapping path definitions to UI pages.

### Feature-Specific Classes
Every new visual or functional vertical in the application MUST be isolated within `lib/feature_{name}` following this strict internal structure:
- `feature_{name}/views`: Contains the UI screen implementation (`{name}_page.dart`).
- `feature_{name}/ui_components`: Local, non-reusable UI widgets tailored uniquely to this feature.
- `feature_{name}/models` *(optional)*: States or DTOs bound singularly to this feature's logic.
- `feature_{name}/blocs`: The `rx_bloc` files reacting to UI inputs to compute states (`{name}_bloc.dart` + generated files).
- `feature_{name}/services`: Middle-layer orchestrators parsing repository data for the BLoC (`{name}_service.dart`).
- `feature_{name}/di`: Dependency injection initializing the BLoC and required dependencies (`{name}_page_with_dependencies.dart`).


## Step-by-Step Execution Plan

### 1. Analyze Inputs
- Use MCP to parse the provided Figma Link and extract the UI design details (widget hierarchy, styling from the design system).
- Analyze the Swagger spec to identify necessary DTOs (Data Transfer Objects) and endpoints.

### 2. Generate Data Layer
- **Models:** Create necessary request/response models in `lib/base/models/` (or feature-specific models) using `json_serializable` and `json_annotation`.
- **Data Sources:** Add new endpoints in `lib/base/data_sources/remote/`. You **MUST use Retrofit** to define these HTTP clients.
    - Create the abstract class using `@RestApi()` and include the `.g.dart` file so `build_runner` can generate the implementation.
  ```dart
  import 'package:dio/dio.dart';
  import 'package:retrofit/retrofit.dart';

  part 'my_feature_remote_data_source.g.dart';

  @RestApi()
  abstract class MyFeatureRemoteDataSource {
    factory MyFeatureRemoteDataSource(Dio dio, {String baseUrl}) =
        _MyFeatureRemoteDataSource;

    @GET('/api/v1/feature')
    Future<List<MyDomainModel>> getAllItems();

    @POST('/api/v1/feature')
    Future<MyDomainModel> addItem(@Body() MyDomainModel item);
  }
  ```
- **Repositories:** Implement or update repositories in `lib/base/repositories/` to map the DTOs to business models and provide them to the services.
    - **Error Handling:** When implementing repository methods, you MUST wrap your data source calls using the `ErrorMapper` (located in `lib/base/common_mappers/error_mappers/error_mapper.dart`). This ensures that specific exceptions (like `DioException`) are properly caught and mapped to unified `ErrorModel` exceptions.
  ```dart
  import 'package:todoapp/base/common_mappers/error_mappers/error_mapper.dart';

  class MyFeatureRepository {
    MyFeatureRepository(this._errorMapper, this._remoteDataSource);

    final ErrorMapper _errorMapper;
    final MyFeatureRemoteDataSource _remoteDataSource;

    Future<MyDomainModel> fetchData() =>
        _errorMapper.execute(() => _remoteDataSource.fetchData());
  }
  ```

### 3. Generate Business Domain Layer
The Domain Layer orchestrates logic between business requirements and the Data Layer. If your feature contains complex logic, data transformations, or requires filtering/syncing, you should implement a `Service` class.

- **Services:** Create your service in `lib/feature_{new_feature_name}/services/` (or `lib/base/common_services/` if highly reusable).
- **Dependency Injection Requirements:** Services MUST act strictly as orchestrators and rely on dependency injection for access to their Repositories.

  ```dart
  import '../models/my_domain_model.dart';
  import '../repositories/my_feature_repository.dart';

  class MyFeatureService {
    // Inject required repositories via the constructor
    MyFeatureService(
      this._repository,
      // Optional: Inject other repositories (e.g., ConnectivityRepository) if needed
    );

    final MyFeatureRepository _repository;

    /// Fetches a list of items and applies business logic
    Future<List<MyDomainModel>> performBusinessLogic() async {
      final List<MyDomainModel> items = await _repository.fetchData();
      
      // Perform any necessary business transformations
      final filteredItems = items.where((item) => item.isValid).toList();
      
      return filteredItems;
    }
  }
  ```

### 4. Generate Presentation Layer (Feature Folder)
Create a new directory `lib/feature_{new_feature_name}` and generate its architecture:

**A. BLoC (Business Logic Component)**
Create `blocs/{name}_bloc.dart`. It should rely on `rx_bloc` to handle UI events and expose streams as state. Ensure you declare the `.rxb.g.dart` generated files in this file as required by `build_runner`.
*Note: The following is an example specifically demonstrating a BLoC that manages **listing with infinite scroll capabilities** utilizing the `rx_bloc_list` package.*

  ```dart
  import 'package:rx_bloc/rx_bloc.dart';
  import 'package:rx_bloc_list/rx_bloc_list.dart';
  import 'package:rxdart/rxdart.dart';

  import '../../base/common_blocs/coordinator_bloc.dart';
  import '../services/my_feature_service.dart';

  part 'my_feature_bloc.rxb.g.dart';

  /// A contract class containing all events of the MyFeatureBloC.
  abstract class MyFeatureBlocEvents {
    /// Triggers a fetch operation for the next page of items.
    void loadPage({bool reset = false});
  }

  /// A contract class containing all states of the MyFeatureBloC.
  abstract class MyFeatureBlocStates {
    /// The resulting state stream of the fetched paginated data.
    Stream<PaginatedList<MyDomainModel>> get paginatedList;

    /// The aggregated loading/error state for the list.
    @RxBlocIgnoreState()
    Stream<bool> get isLoading;

    @RxBlocIgnoreState()
    Stream<String> get errors;
  }

  @RxBloc()
  class MyFeatureBloc extends $MyFeatureBloc {
    MyFeatureBloc(
      this._service,
      this._coordinatorBloc,
    ) {
      _$loadPageEvent
          .startWith(const _LoadPageEventArgs(reset: true))
          .fetchPaginatedList(
            (reset) => _service.fetchPaginatedData(reset),
          )
          .setResultStateHandler(this)
          .bind(_paginatedList)
          .addTo(_compositeSubscription);
    }

    final MyFeatureService _service;
    final CoordinatorBlocType _coordinatorBloc;

    final _paginatedList = BehaviorSubject<PaginatedList<MyDomainModel>>.seeded(
      PaginatedList<MyDomainModel>(
        list: [],
        pageSize: 10,
        totalCount: 0,
      ),
    );

    @override
    Stream<PaginatedList<MyDomainModel>> _mapToPaginatedListState() =>
        _paginatedList;

    @override
    Stream<bool> get isLoading => loadingState;

    @override
    Stream<String> get errors => errorState.map((error) => error.toString());

    @override
    void dispose() {
      _paginatedList.closeSafely();
      super.dispose();
    }
  }
  ```

*Note: The following is an example demonstrating a BLoC that manages **a details page** requesting a single specific model and handling generic routing within the BLoC.*

  ```dart
  import 'dart:async';

  import 'package:rx_bloc/rx_bloc.dart';
  import 'package:rxdart/rxdart.dart';

  import '../../base/common_blocs/coordinator_bloc.dart';
  import '../../base/models/my_domain_model.dart';
  import '../../lib_router/blocs/router_bloc.dart';
  import '../services/my_feature_service.dart';

  part 'my_details_bloc.rxb.g.dart';

  abstract class MyDetailsBlocEvents {
    /// Dispatches a fetch instruction
    void fetchDetails();

    /// Triggers navigation behavior to a specific route
    void onActionTapped();
  }

  abstract class MyDetailsBlocStates {
    /// The stream emitting the result of the details fetch.
    ConnectableStream<Result<MyDomainModel>> get details;

    /// Trigger routing behaviors from the UI through this stream
    ConnectableStream<void> get onRouting;

    Stream<bool> get isLoading;
    Stream<String> get errors;
  }

  @RxBloc()
  class MyDetailsBloc extends $MyDetailsBloc {
    MyDetailsBloc(
      this._itemId,
      this._initialItem,
      this._service,
      this._coordinatorBloc,
      this._routerBloc,
    ) {
      details.connect().addTo(_compositeSubscription);
      onRouting.connect().addTo(_compositeSubscription);
    }

    final MyFeatureService _service;
    final CoordinatorBlocType _coordinatorBloc;
    final RouterBlocType _routerBloc;
    final String _itemId;
    final MyDomainModel? _initialItem;

    @override
    ConnectableStream<Result<MyDomainModel>> _mapToDetailsState() =>
        _$fetchDetailsEvent
            .startWith(null)
            .switchMap(
              (_) => _service.fetchDetailsById(_itemId, _initialItem).asResultStream(),
            )
            .setResultStateHandler(this)
            .mergeWith([
          _coordinatorBloc.states.onItemUpdated
              .whereSuccess()
              .where((updatedItem) => _itemId == updatedItem.id)
              .mapToResult()
        ]).publish();

    @override
    ConnectableStream<void> _mapToOnRoutingState() => _$onActionTappedEvent
        .withLatestFrom(details, (_, model) => model)
        .whereSuccess()
        .doOnData(
          (item) =>
              _routerBloc.events.push(MyUpdatingRoute(item.id!), extra: item),
        )
        .publish();

    @override
    Stream<bool> _mapToIsLoadingState() => loadingState;
    
    @override
    Stream<String> get errors => errorState.map((error) => error.toString());
  }
  ```

*Note: The following is an example demonstrating a BLoC that handles **management configurations (Forms, Creation, Updating)** where UI interactions flow through the BLoC for validation and submission.*

  ```dart
  import 'dart:async';

  import 'package:rx_bloc/rx_bloc.dart';
  import 'package:rxdart/rxdart.dart';

  import '../../base/common_blocs/coordinator_bloc.dart';
  import '../../base/models/my_domain_model.dart';
  import '../../lib_router/blocs/router_bloc.dart';
  import '../services/my_manage_service.dart';

  part 'my_manage_bloc.rxb.g.dart';

  abstract class MyManageBlocEvents {
    /// Sets the title field of the model.
    @RxBlocEvent(type: RxBlocEventType.behaviour)
    void setTitle(String title);

    /// Dispatches a save action.
    void save();
  }

  abstract class MyManageBlocStates {
    /// The stream of the title or an error if invalid.
    Stream<String> get title;

    /// Streams validation error visibility.
    Stream<bool> get showError;

    Stream<bool> get isLoading;

    /// The stream emitting the result of the submission.
    ConnectableStream<MyDomainModel> get onSaved;
  }

  @RxBloc()
  class MyManageBloc extends $MyManageBloc {
    MyManageBloc(
      this._itemId,
      this._initialItem,
      this._manageService,
      this._coordinatorBloc,
      this._routerBloc,
    ) {
      onSaved.connect().addTo(_compositeSubscription);
      
      // Seed _itemSubject with _initialItem if Editing
      if (_initialItem != null) {
        _itemSubject.add(_initialItem!);
      }
    }

    final MyManageService _manageService;
    final CoordinatorBlocType _coordinatorBloc;
    final RouterBlocType _routerBloc;
    final String? _itemId;
    final MyDomainModel? _initialItem;

    final _itemSubject = BehaviorSubject<MyDomainModel>();

    @override
    Stream<String> _mapToTitleState() => Rx.merge([
          _$setTitleEvent.startWith(''),
          _itemSubject.map((item) => item.title),
        ]).shareReplay(maxSize: 1);

    @override
    ConnectableStream<MyDomainModel> _mapToOnSavedState() => _$saveEvent
        .withLatestFrom(title, (_, titleText) => titleText)
        .switchMap(
          (titleText) =>
              _manageService.addOrUpdate(_itemId, titleText).asResultStream(),
        )
        .setResultStateHandler(this)
        .doOnData(_coordinatorBloc.events.itemAddedOrUpdated)
        .whereSuccess()
        .doOnData((item) => _routerBloc.events.pop())
        .publish();

    @override
    Stream<bool> _mapToIsLoadingState() => loadingState;

    @override
    Stream<bool> _mapToShowErrorState() =>
        _$saveEvent.mapTo(true).startWith(false);

    @override
    void dispose() {
      _itemSubject.closeSafely();
      super.dispose();
    }
  }
  ```

**B. Cross-BLoC Orchestration (CoordinatorBloc)**
The application utilizes a singleton/global `CoordinatorBloc` (located in `lib/base/common_blocs/coordinator_bloc.dart`) to manage communication between completely decoupled BLoCs (e.g., between List, Details, and Manage BLoCs).

- **Role:** If a feature updates, deletes, or adds a global entity, it should push that event to the `CoordinatorBloc`. Other BLoCs interested in this entity listen to the `CoordinatorBloc`'s states and merge those updates into their own localized streams.
- **Example Flow - Creation/Updating (Manage -> List):**
    1. The `MyManageBloc` successfully performs an API update via its service.
    2. It immediately pushes the result into the coordinator: `.doOnData(_coordinatorBloc.events.itemAddedOrUpdated)`
    3. The `MyListBloc` (or `MyDetailsBloc`) listens for this global state: `_coordinatorBloc.states.onItemUpdated.whereSuccess()`
    4. The List/Details BLoC merges this updated item into its own state stream (acting as a localized reactivity point) without ever needing to know about `MyManageBloc`.

**C. Dependency Injection (DI)**
Create `di/{name}_page_with_dependencies.dart` that initializes your BLoC and any specific dependencies required.

**C. View & UI Components**
Build the UI in `views/{name}_page.dart` focusing on the Figma design. Ensure you use the centralized design system (`context.designSystem`) for typography, colors, and layout spacing.

### 4. Register the Routing

Follow these exact steps to register the new feature in the application's routing and access control systems.

**A. Define Route Path**
Add your feature path in `lib/lib_router/models/routes_path.dart`:

```dart
class RoutesPath {
  static const myNewFeature = 'my-new-feature';
  // ... existing paths
}
```

**B. Define Route Permission**
Add your feature permission name in `lib/lib_permissions/models/route_permissions.dart`:

```dart
class RoutePermissions {
  static const myNewFeature = 'MyNewFeatureRoute';
  // ... existing routes
}
```

**C. Declare Route Model**
Register the new route in the `RouteModel` enum located in `lib/lib_router/models/route_model.dart`:

```dart
enum RouteModel {
  myNewFeature(
      pathName: RoutesPath.myNewFeature,
      fullPath: '/my-new-feature',
      permissionName: RoutePermissions.myNewFeature,
  ),
  // ... existing routes
}
```

**D. Create the Route Configuration**
Create the specific route mapping using `typed_go_router` under `lib/lib_router/routes/` files (usually `routes.dart` or a specific flow route file):

```dart
@TypedGoRoute<MyFeatureRoute>(path: RoutesPath.myNewFeature)
@immutable
class MyFeatureRoute extends GoRouteData implements RouteDataModel {
  const MyFeatureRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const MyFeaturePage(),
      );

  @override
  String get permissionName => RouteModel.myNewFeature.permissionName;

  @override
  String get routeLocation => location;
}
```

**E. Navigation Usage**
Once registered, navigate to the feature using the `RouterBloc`:

```dart
// Navigating using go
context.read<RouterBlocType>().events.go(const MyFeatureRoute());

// Or using push
context.read<RouterBlocType>().events.push(const MyFeatureRoute());
```

### 5. Finalize
- Run code generation commands (`flutter pub run build_runner build --delete-conflicting-outputs`) to generate Retrofit, JsonSerializable, and RxBloc files.
- Add localizations in `lib/l10n/arb/en.arb` for new strings, and follow the project's translation sync process via `bin/sync_translations.py`.

## Testing Structure (Unit & Golden)

The `todoapp` project expects thorough testing for any new feature. Tests must reside in the `test/` directory, mirroring the structure of `lib/`.

### 1. Global Test Data (Stubs)
Before writing tests, define reusable mock entities in `test/stubs.dart`. This ensures consistency across all unit and golden tests and reduces hardcoded duplicates.
- All mock data elements (e.g., initialized `MyDomainModel` with complete parameters or pre-populated `PaginatedList` objects) must be registered globally as static constants or getters under the `Stubs` class.

### 2. Unit Testing BLoCs
All BLoCs must be unit-tested using `rx_bloc_test` and `mockito`.
- **Location:** `test/feature_{name}/blocs/{name}_bloc_test.dart`
- **Setup:** Create a mock of your Service (e.g., `MockMyFeatureService`) using `@GenerateMocks`. If checking routing or cross-feature coordination, use the globally provided stubs/factories (like `coordinatorBlocMockFactory`).
- **Testing Requirements:** Validate event streams against discrete state transitions (like asserting `Result.loading()` followed by `Result.success(Stubs.mockModel)` inside the `expect:` array).

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../stubs.dart';
import 'my_feature_test.mocks.dart';

@GenerateMocks([
  MyFeatureService,
])
void main() {
  late MyFeatureService service;
  late CoordinatorBlocType coordinatorBloc;
  late CoordinatorStates coordinatorBlocStates;

  void defineWhen({List<MyDomainModel>? items}) {
    items ??= Stubs.mockList;

    when(service.fetchData())
        .thenAnswer((_) => Stream.value(items!));

    when(coordinatorBlocStates.onItemUpdated)
        .thenAnswer((_) => Stream.value(Result.success(Stubs.mockModel)));
  }

  MyFeatureBloc buildBloc() => MyFeatureBloc(
        service,
        coordinatorBloc,
      );

  setUp(() {
    service = MockMyFeatureService();
    coordinatorBlocStates = coordinatorStatesMockFactory();
    coordinatorBloc = coordinatorBlocMockFactory(states: coordinatorBlocStates);
    when(coordinatorBloc.states).thenReturn(coordinatorBlocStates);
  });

  group('MyFeatureBloc tests', () {
    rxBlocTest<MyFeatureBlocType, Result<List<MyDomainModel>>>(
        'Test successful fetch operation',
        build: () async {
          defineWhen(items: Stubs.mockList);
          return buildBloc();
        },
        act: (bloc) async => bloc.events.fetchData(),
        state: (bloc) => bloc.states.dataResult,
        expect: [
          Result.success([]),
          Result.loading(),
          Result.success(Stubs.mockList)
        ],
    );
  });
}
```

### 3. Golden Testing Views & Mock Factories
UI Components and Views must be governed by Golden tests leveraging `golden_toolkit`. To mock BLoC states effectively without running actual logic, you must construct a test factory structure.

**A. Create Mock Implementations**
In `test/feature_{name}/mock/{name}_mock.dart`, establish dummy BLoC implementations whose state streams simply return explicitly injected values.
```dart
MyFeatureBlocType myFeatureMockFactory({Result<MyDomainModel>? dataResult}) {
  final bloc = MockMyFeatureBlocType();
  final states = MockMyFeatureBlocStates();
  
  when(states.dataResult)
      .thenAnswer((_) => Stream.value(dataResult ?? Result.success(Stubs.mockModel)));
      
  when(bloc.states).thenReturn(states);
  return bloc;
}
```

**B. Create a Widget Factory**
In `test/feature_{name}/factory/{name}_factory.dart`, construct a Wrapper Widget that directly injects the BLoC mock instances from above using `RxBlocProvider`:
```dart
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

Widget myFeatureFactory({
  Result<MyDomainModel>? dataResult,
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [
          RxBlocProvider<MyFeatureBlocType>.value(
            value: myFeatureMockFactory(dataResult: dataResult),
          ),
        ],
        child: const MyFeaturePage(),
      ),
    );
```

**C. Execute Golden Tests**
In `test/feature_{name}/view/{name}_golden_test.dart`, use the factory sequentially for every visual state your UI expects:
```dart
void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'my_feature_loading_state',
      widget: myFeatureFactory(
        dataResult: Result.loading(),
      ),
    ),
    buildScenario(
      scenario: 'my_feature_success_state',
      widget: myFeatureFactory(
        dataResult: Result.success(Stubs.mockModel),
      ),
    ),
    buildScenario(
      scenario: 'my_feature_error_state',
      widget: myFeatureFactory(
        dataResult: Result.error(UnknownErrorModel(exception: Exception('Oops'))),
      ),
    ),
  ]);
}
```

By following these architecture and testing guidelines strictly, you will produce seamless, clean, scalable enhancements fully integrated into the `todoapp` pipeline.

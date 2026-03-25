---
description: Create a new feature in the Flutter project - Complete feature scaffolding including data layer, business logic, presentation layer, and routing
---

# Create a New Feature

This skill guides the AI agent in creating a new feature in the Flutter project, adhering strictly to the established architecture and RxBloc patterns.

> **Reference implementation:** `lib/feature_profile/` and `lib/feature_accounts/` — these are canonical examples

## Inputs Required

To successfully execute this skill, the following inputs MUST be provided:
1. **Feature name:** The name for the new feature (e.g., `transfer_history`, `card_details`)
2. **Figma Link (optional, using MCP):** The design file containing the UI layout, colors, typography, and intended interactions for the new feature.
3. **Swagger (Open API) Specification (optional):** The API documentation defining the needed API endpoints, request models, and response models.

## Core Principle

**Architecture compliance > Feature completeness > Speed**

Every new feature must follow the exact patterns from the reference implementations. The agent must understand the project architecture before generating any code.

## Step-by-Step Execution Plan

### 1. Analysis Phase (Before Generating)

Before generating any code, the agent MUST:

- [ ] Determine the feature name in snake_case (e.g., `my_new_feature`)
- [ ] Review the Figma design (if provided) to understand UI requirements
- [ ] Review the Swagger spec (if provided) to identify API endpoints and models
- [ ] Check `lib/base/models/` for existing models that can be reused
- [ ] Check `lib/base/repositories/` for existing repositories
- [ ] Check `lib/base/common_services/` for existing services
- [ ] **Scan `lib/base/common_ui_components/`** for existing reusable widgets (error states, loaders, buttons, list items, etc.) that can be used as-is before creating new ones
- [ ] **Review `lib/base/theme/design_system/`** to understand available colors, typography styles, spacing tokens, and icons — all UI values MUST come from here
- [ ] Enumerate all pages/screens needed for the feature
- [ ] Identify which BLoC pattern to use (list, details, or manage)

### 2. Generate Data Layer
- **Models:** Create necessary request/response models in `lib/base/models/` using `json_serializable` and `json_annotation`. Feature-specific models can optionally go in `lib/feature_{name}/models/`.
- **Data Sources:** Add new endpoints in `lib/base/data_sources/remote/`. You **MUST use Retrofit** to define these HTTP clients.
    - Create the abstract class using `@RestApi()` and include the `.g.dart` file so `build_runner` can generate the implementation.
  ```dart
  import 'package:dio/dio.dart';
  import 'package:retrofit/error_logger.dart';
  import 'package:retrofit/http.dart';

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
- **Repositories:** Implement repositories in `lib/base/repositories/` to interact with data sources and provide data to services.
    - **Error Handling:** When implementing repository methods, you MUST wrap your data source calls using the `ErrorMapper` (located in `lib/base/common_mappers/error_mappers/error_mapper.dart`). This ensures that specific exceptions (like `DioException`) are properly caught and mapped to unified `ErrorModel` exceptions.
  ```dart
  import '../common_mappers/error_mappers/error_mapper.dart';

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

- **Services:** Create your service in `lib/feature_{new_feature_name}/services/`.
- **Dependency Injection:** Services act as orchestrators and rely on dependency injection for access to repositories and other services.

  ```dart
  class MyFeatureService {
    //Add repository dependencies as needed
    MyFeatureService();

    Future<String> fetchData() async {
      // Perform business logic, data transformations, or call repositories
      await Future.delayed(const Duration(seconds: 1));
      return 'Data fetched successfully';
    }
  }
  ```

  **With Repository Dependencies:**
  ```dart
  import '../../base/repositories/my_feature_repository.dart';

  class MyFeatureService {
    MyFeatureService(this._repository);

    final MyFeatureRepository _repository;

    /// Fetches data and applies business logic
    Future<List<MyDomainModel>> performBusinessLogic() async {
      final items = await _repository.fetchData();
      
      // Perform any necessary business transformations
      return items.where((item) => item.isValid).toList();
    }
  }
  ```

  **infinite scroll capabilities service example**
  ```dart
  import 'package:rx_bloc_list/rx_bloc_list.dart';

  import '../../base/repositories/my_feature_repository.dart';
  import '../../base/models/my_domain/my_domain_model.dart';

  class MyFeatureService {
    MyFeatureService(this._repository);

    final MyFeatureRepository _repository;

    Future<PaginatedList<MyDomainModel>> fetchPaginatedData({
      int page = 1,
      int pageSize = 10,
    }) async {
      final response = await _repository.fetchPaginatedData(
        page: page,
        pageSize: pageSize,
      );

      return PaginatedList<MyDomainModel>(
        list: response.items,
        pageSize: pageSize,
        totalCount: response.totalCount,
      );
    }
  }
  ```

### 4. Generate Presentation Layer (Feature Folder)
Create a new directory `lib/feature_{new_feature_name}` and generate its architecture:

**A. BLoC (Business Logic Component)**
Create `blocs/{name}_bloc.dart`. It should rely on `rx_bloc` to handle UI events and expose streams as state. Ensure you declare the `.rxb.g.dart` generated files in this file as required by `build_runner`.

*Note: The following is an example of a simple BLoC that manages state with loading and error handling:*

  ```dart
  import 'package:rx_bloc/rx_bloc.dart';
  import 'package:rxdart/rxdart.dart';

  import '../../base/extensions/error_model_extensions.dart';
  import '../../base/models/errors/error_model.dart';
  import '../services/my_feature_service.dart';

  part 'my_feature_bloc.rxb.g.dart';

  /// A contract class containing all events of the MyFeatureBloC.
  abstract class MyFeatureBlocEvents {
    /// TODO: Document the event
    void fetchData();
  }

  /// A contract class containing all states of the MyFeatureBloC.
  abstract class MyFeatureBlocStates {
    /// The loading state
    Stream<bool> get isLoading;

    /// The error state
    Stream<ErrorModel> get errors;

    /// TODO: Document the state
    Stream<Result<String>> get data;
  }

  @RxBloc()
  class MyFeatureBloc extends $MyFeatureBloc {
    MyFeatureBloc(this.myFeatureService);

    final MyFeatureService myFeatureService;

    @override
    Stream<Result<String>> _mapToDataState() => _$fetchDataEvent
        .startWith(null)
        .switchMap((value) => myFeatureService.fetchData().asResultStream())
        .setResultStateHandler(this)
        .shareReplay(maxSize: 1);

    @override
    Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

    @override
    Stream<bool> _mapToIsLoadingState() => loadingState;
  }
  ```


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
          .startWith(true)
          .switchMap(
            (reset) {
              if (reset) _paginatedList.value.reset();

              return _service
                  .fetchPaginatedData(
                    page: _paginatedList.value.pageNumber + 1,
                    pageSize: _paginatedList.value.pageSize,
                  )
                  .asResultStream();
            },
          )
          // Enable state handling by the current bloc
          .setResultStateHandler(this)
          // Merge the data in the _paginatedList
          .mergeWithPaginatedList(_paginatedList)
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

*Note: The following is an example demonstrating a BLoC that handles **form management and validation** where UI interactions flow through the BLoC.*

  ```dart
  import 'package:go_router/go_router.dart';
  import 'package:rx_bloc/rx_bloc.dart';
  import 'package:rxdart/rxdart.dart';

  import '../../base/common_blocs/coordinator_bloc.dart';
  import '../../base/common_services/validators/credentials_validator_service.dart';
  import '../../base/extensions/error_model_extensions.dart';
  import '../../base/models/errors/error_model.dart';
  import '../../lib_router/router.dart';
  import '../services/my_feature_service.dart';

  part 'my_feature_bloc.rxb.g.dart';

  /// A contract class containing all events of the MyFeatureBloC.
  abstract class MyFeatureBlocEvents {
    @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
    void setEmail(String email);

    @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
    void setPassword(String password);

    void submit();
  }

  /// A contract class containing all states of the MyFeatureBloC.
  abstract class MyFeatureBlocStates {
    /// The currently entered email state
    Stream<String> get email;

    /// The currently entered password state
    Stream<String> get password;

    /// State indicating whether the submission was successful
    ConnectableStream<bool> get submitted;

    /// The state indicating whether we show errors to the user
    Stream<bool> get showErrors;

    /// The loading state
    Stream<bool> get isLoading;

    /// The error state
    Stream<ErrorModel> get errors;
  }

  @RxBloc()
  class MyFeatureBloc extends $MyFeatureBloc {
    MyFeatureBloc(
      this._coordinatorBloc,
      this._myFeatureService,
      this._validatorService,
      this._router,
    ) {
      submitted.connect().addTo(_compositeSubscription);
    }

    final CoordinatorBlocType _coordinatorBloc;
    final MyFeatureService _myFeatureService;
    final CredentialsValidatorService _validatorService;
    final AppRouter _router;

    @override
    Stream<String> _mapToEmailState() => _$setEmailEvent
        .map(_validatorService.validateEmail)
        .startWith('')
        .shareReplay(maxSize: 1);

    @override
    Stream<String> _mapToPasswordState() => _$setPasswordEvent
        .map(_validatorService.validatePassword)
        .startWith('')
        .shareReplay(maxSize: 1);

    @override
    ConnectableStream<bool> _mapToSubmittedState() => _$submitEvent
        .throttleTime(const Duration(seconds: 1))
        .withLatestFrom2<Result<String>, Result<String>, MyCredentials?>(
          email.asResultStream(),
          password.asResultStream(),
          (_, emailResult, passwordResult) =>
              _validateAndReturnCredentials(emailResult, passwordResult),
        )
        .where((args) => args != null)
        .exhaustMap(
          (args) => _myFeatureService
              .processData(email: args!.email, password: args.password)
              .then((value) => true)
              .asResultStream(),
        )
        .setResultStateHandler(this)
        .whereSuccess()
        .doOnData((_) => _router.go(const DashboardRoute().location))
        .startWith(false)
        .publish();

    @override
    Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

    @override
    Stream<bool> _mapToIsLoadingState() => loadingState;

    @override
    Stream<bool> _mapToShowErrorsState() =>
        _$submitEvent.mapTo(true).startWith(false);

    MyCredentials? _validateAndReturnCredentials(
      Result<String> emailResult,
      Result<String> passwordResult,
    ) {
      if (emailResult is ResultError || passwordResult is ResultError) {
        return null;
      }
      if (emailResult is ResultLoading || passwordResult is ResultLoading) {
        return null;
      }

      return MyCredentials(
        email: (emailResult as ResultSuccess<String>).data,
        password: (passwordResult as ResultSuccess<String>).data,
      );
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
Create `di/{name}_page_with_dependencies.dart` that initializes your BLoC and any specific dependencies required. The page wraps the actual view with services and BLoCs using `MultiProvider`.

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/my_feature_bloc.dart';
import '../services/my_feature_service.dart';
import '../views/my_feature_page.dart';

class MyFeaturePageWithDependencies extends StatelessWidget {
  const MyFeaturePageWithDependencies({super.key});

  List<Provider> get _services => [
    Provider<MyFeatureService>(
      create: (context) => MyFeatureService(
        context.read(), // Repository from parent context
        context.read(), // Another dependency
      ),
    ),
  ];

  List<RxBlocProvider> get _blocs => [
    RxBlocProvider<MyFeatureBlocType>(
      create: (context) => MyFeatureBloc(
        context.read(), // Service injected
        context.read(), // EventsBlocType or other bloc
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [..._services, ..._blocs],
    child: const MyFeaturePage(),
  );
}
```

**D. View & UI Components**
Build the UI in `views/{name}_page.dart` focusing on the Figma design.

**Design System — mandatory:**
All visual values MUST come from `context.designSystem`. Never use raw Material constants or hardcoded values.

```dart
// ✅ Correct
Text(
  context.l10n.hello,
  style: context.designSystem.typography.textTheme.bodyLarge,
)
ColoredBox(color: context.designSystem.colors.colorScheme.primary)
SizedBox(height: context.designSystem.spacing.m)

// ❌ Wrong
Text('Hello', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
ColoredBox(color: Colors.blue)
SizedBox(height: 16)
```

If the required color, typography style, spacing value, or icon is missing from the design system, **add it to the appropriate file in `lib/base/theme/design_system/`** rather than hardcoding it at the call site.

**Reusable components — check before creating:**
Always check `lib/base/common_ui_components/` for an existing widget before building a new one. Common examples include:
- Error states → use `AppErrorWidget` (or equivalent) rather than writing a custom error view
- Loading indicators → use the project's shared loading widget
- Buttons, list tiles, avatars, empty-state views — check if they already exist

Only create a new widget in `feature_{name}/ui_components/` if no suitable reusable component exists. If you create something that is clearly reusable across features, place it in `lib/base/common_ui_components/` instead.

**Strings & Localisation — mandatory:**
Every user-visible string MUST go through the l10n system. Never use raw string literals in the UI.

Workflow:
1. **Extract strings from Figma** (labels, titles, button text, placeholders, error messages, etc.)
2. **Add each string to every `.arb` file** in `lib/l10n/arb/` (e.g., `en.arb`, `de.arb`, …). Use a `feature_<name>_` prefix to keep keys namespaced:
   ```json
   // en.arb
   "featureMyNameTitle": "My Feature",
   "featureMyNameEmptyState": "Nothing here yet.",
   "featureMyNameRetryButton": "Retry"
   ```
3. **Run code generation** so the typed accessors are created:
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   # or
   bin/build_runner_build.sh
   ```
4. **Use the generated accessors in the UI** via `context.l10n.<key>`:
   ```dart
   Text(context.l10n.featureMyNameTitle)
   ElevatedButton(onPressed: onRetry, child: Text(context.l10n.featureMyNameRetryButton))
   ```

If a string appears in Figma but no translation exists in the `.arb` files yet, add it — do not inline the raw English string as a fallback.

### Error Handling

The application follows a strict error handling architecture across all layers:

#### Data Source/Server Side Validations
All data source related errors (such as `DioException`, `GeneralSecurityException`, etc.) are treated as DTOs. Each repository is responsible for mapping Error DTOs to Business Errors (such as `ErrorAccessModel`, `ErrorNotFound`, etc.) using the `ErrorMapper` which should be injected into each Repository.

#### Client Side Validations
The `Service` layer is responsible for throwing client-side validation exceptions (e.g., `ErrorRequiredFieldModel`) instead of the data layer.

#### BLoC Error Handling
Each BLoC should expose its errors via a dedicated state stream for UI visualization:

```dart
/// The error state
ConnectableStream<ErrorModel> get errors;
```

The `ErrorModel` can be mapped to appropriate UI representation using `error_model_extensions.dart`.

#### User Friendly Messages
To provide user-friendly (translated) messages, the `ErrorModel` should be translated in the UI Layer by calling:

```dart
error.translate(context)
```

If a new Business Error is introduced, it should be translated/mapped in `ErrorModelX.translate` (see `error_model_translations.dart`).

#### Form Validations
Each form validator should throw a business error that is translated in the UI Layer by calling `translateErrors(context)`:

```dart
RxTextFormFieldBuilder<MyBlocType>(
  state: (bloc) => bloc.states.fieldName.translateErrors(context),
  // ...
)
```

When a new client-side error type is introduced, it should be mapped to `RxFieldException` in the extension method `translateErrors` located in `stream_translate_field_extension.dart`.

### 4. Register the Routing

Follow these exact steps to register the new feature in the application's routing and access control systems. The application uses **Declarative Routing** with [GoRouter](https://pub.dev/packages/go_router) and [go_router_builder](https://pub.dev/packages/go_router_builder).

**A. Define Route Path**
Add your feature path in `lib/lib_router/models/routes_path.dart`:

```dart
class RoutesPath {
  // ... existing paths
  static const myNewFeature = '/my-new-feature';
}
```

**B. Define Route Permission**
Add the route permission in `lib/lib_permissions/models/route_permissions.dart`:

```dart
class RoutePermissions {
  // ... existing permissions
  static const myNewFeature = 'MyNewFeatureRoute';
}
```

**C. Define Route Model**
Add the route enum entry in `lib/lib_router/models/route_model.dart`:

```dart
enum RouteModel {
  // ... existing routes
  myNewFeature(
    pathName: RoutesPath.myNewFeature,
    fullPath: '/my-new-feature',
    permissionName: RoutePermissions.myNewFeature,
  ),
  // ...
}
```

**D. Create the Route Configuration**
Create the specific route mapping using `@TypedGoRoute` under `lib/lib_router/routes/` files (usually `routes.dart` or a specific feature route file like `{feature}_routes.dart`):

```dart
part of '../router.dart';

@TypedGoRoute<MyFeatureRoute>(path: RoutesPath.myNewFeature)
@immutable
class MyFeatureRoute extends GoRouteData
    with $MyFeatureRoute
    implements RouteDataModel {
  const MyFeatureRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const MyFeaturePageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.myNewFeature.permissionName;

  @override
  String get routeLocation => location;
}
```

**E. Register Nested Routes (if applicable)**
For nested routes within a flow, register them as children of the parent route:

```dart
@TypedGoRoute<ParentRoute>(
  path: _Paths.parent,
  routes: [
    TypedGoRoute<MyFeatureRoute>(
      path: _Paths.myNewFeature,
      name: RouteName.myNewFeature,
    ),
  ],
)
```

**F. Navigation Usage**
Once registered, navigate to the feature using the router:

```dart
// Navigating using go (replaces entire stack)
context.read<AppRouter>().go(const MyFeatureRoute().location);

// Or using push (adds to stack)
context.read<AppRouter>().push(const MyFeatureRoute().location);
```

### 5. Finalize

- **Localization:** Add localizations in `lib/l10n/arb/en.arb` for new strings. Use the `r_flutter` package format for translations. Access translations via `context.l10n.someTranslationKey`.
- **Translation Sync:** Run `./bin/update_translations.py` from the project root to propagate new strings to other language files.
  - *Note:* If your Python distribution does not ship with the yaml module, install it by running `pip3 install pyyaml`.
- **Code Generation:** Run code generation commands to generate Retrofit, JsonSerializable, and RxBloc files:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
  Or simply run `bin/build_runner_build.sh`.

### 6. Testing

After creating the feature, tests should be created following the project's testing patterns:

- **Unit Tests:** Create unit tests for services and BLoCs in `test/feature_<name>/`
- **Golden Tests:** Create golden tests for pages in `test/feature_<name>/view/`

Refer to the `unit_test` and `golden_test` skills for detailed testing guidelines.

## Directory Structure (MANDATORY)

```
lib/feature_<name>/
├── blocs/                              # BLoC files
│   ├── <name>_bloc.dart
│   └── <name>_bloc.rxb.g.dart          # Auto-generated by build_runner
├── di/                                 # Dependency injection
│   └── <name>_page_with_dependencies.dart
├── services/                           # Feature-specific services
│   └── <name>_service.dart
├── views/                              # UI pages
│   └── <name>_page.dart
├── ui_components/                      # Feature-specific widgets (optional)
│   └── <widget_name>.dart
└── models/                             # Feature-specific models (optional)
    └── <model_name>.dart
```

## File Naming Conventions (MANDATORY)

| Artifact | Pattern | Example |
|---|---|---|
| BLoC file | `<name>_bloc.dart` | `profile_bloc.dart` |
| Generated BLoC | `<name>_bloc.rxb.g.dart` | `profile_bloc.rxb.g.dart` |
| Service file | `<name>_service.dart` | `profile_service.dart` |
| Page file | `<name>_page.dart` | `profile_page.dart` |
| DI file | `<name>_page_with_dependencies.dart` | `profile_page_with_dependencies.dart` |
| Repository | `<name>_repository.dart` | `profile_repository.dart` |
| Data source | `<name>_remote_data_source.dart` | `profile_remote_data_source.dart` |

## Forbidden Actions

- **NEVER** create a BLoC without the corresponding `.rxb.g.dart` part directive
- **NEVER** instantiate services or repositories directly in BLoCs — use dependency injection
- **NEVER** put business logic in the UI layer (pages/widgets)
- **NEVER** call APIs directly from BLoCs — use services and repositories
- **NEVER** skip error handling with `ErrorMapper` in repositories
- **NEVER** hardcode strings — use localization keys
- **NEVER** create routes without registering them in the router
- **NEVER** use `setState` in pages — use BLoC states instead
- **NEVER** create feature-specific models in `lib/base/models/` — put them in `lib/feature_<name>/models/`
- **NEVER** use hardcoded colors, font sizes, font weights, spacing/padding values, or icons — always use `context.designSystem.*`; if the value doesn't exist yet, add it to `lib/base/theme/design_system/`
- **NEVER** write a custom error, loading, or empty-state widget without first checking `lib/base/common_ui_components/` for an existing one
- **NEVER** use raw string literals in the UI — every user-visible string must be an l10n key in the `.arb` files and accessed via `context.l10n.<key>`

## Reference: Key Import Paths

### In BLoC files:

```dart
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../base/common_blocs/coordinator_bloc.dart';
import '../services/<name>_service.dart';

part '<name>_bloc.rxb.g.dart';
```

### In Service files:

```dart
import '../../base/repositories/<name>_repository.dart';
import '../../base/models/<domain>/<model>.dart';
```

### In DI files:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import '../blocs/<name>_bloc.dart';
import '../services/<name>_service.dart';
import '../views/<name>_page.dart';
```

### In Route files:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../feature_<name>/di/<name>_page_with_dependencies.dart';
```

## Ambiguous Case Rule

If the agent cannot clearly determine:

- What API endpoints are needed, OR
- What UI states the page should handle, OR
- What navigation flow is required

Then the agent MUST ask for clarification before proceeding. **Never guess.**

By following these architecture guidelines strictly, you will produce seamless, clean, scalable features fully integrated into the project.

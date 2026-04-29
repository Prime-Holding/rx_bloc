---
name: create_feature
description: Create a new feature — implement a screen, add a page, scaffold a flow, implement an API spec (OpenAPI/Swagger), or build a new data layer + UI. Use for ANY prompt that mentions: feature, screen, page, API spec, swagger, openapi, implement, build from spec.
---

# Create a New Feature

This skill guides the AI agent in creating a new feature in the Flutter project, adhering strictly to the established architecture and RxBloc patterns.

> **Reference implementation:** `lib/feature_profile/` and `lib/feature_accounts/` — these are canonical examples

## Inputs Required

To successfully execute this skill, the following inputs MUST be provided:
1. **Feature name:** The name for the new feature (e.g., `transfer_history`, `card_details`)
2. **Figma Link (optional, using MCP):** The design file containing the UI layout, colors, typography, and intended interactions for the new feature. If any Figma links are provided, they MUST be read using Figma MCP.
3. **Swagger (Open API) Specification (optional):** The API documentation defining the needed API endpoints, request models, and response models.
4. **Multiple BLoCs (optional, explicit only):** If the user wants more than one feature-scoped BLoC, they must say so — otherwise the agent should create one BLoC per feature (default).

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
- [ ] For any new or changed Retrofit remote data source, plan **only** the abstract API + `part` — the implementation is **generated** by `build_runner`; do not sketch manual `Dio`/`*.g.dart` code
- [ ] Check `lib/base/common_services/` for existing services
- [ ] **Scan `lib/base/common_ui_components/`** for existing reusable widgets (error states, loaders, buttons, list items, etc.) that can be used as-is before creating new ones
- [ ] **Review `lib/base/theme/design_system/`** to understand available colors, typography styles, spacing tokens, and icons — all UI values MUST come from here
- [ ] Enumerate all pages/screens needed for the feature
- [ ] Unless the user explicitly requested multiple feature BLoCs, plan **one** BLoC for the feature
- [ ] Identify which BLoC pattern to use (list, details, or manage)
- [ ] For that BLoC, list **only** the state streams the page(s) will **actually** subscribe to; do not add unused states to mirror examples

### 2. Generate Data Layer

**Models — definition of done (MUST be satisfied before moving on):**
- [ ] Every public class/enum has a `///` summary.
- [ ] Every public field, getter, and constructor is documented.

- **Models:** Create necessary request/response models in `lib/base/models/` using `json_serializable` and `json_annotation`. Feature-specific models can optionally go in `lib/feature_{name}/models/`. Do not add docs in generated `*.g.dart` files (excluded at package root). Example shape:

  ```dart
  import 'package:json_annotation/json_annotation.dart';

  part 'my_item_model.g.dart';

  /// A single row from the list endpoint response body.
  @JsonSerializable()
  class MyItemModel {
    /// Creates a [MyItemModel].
    const MyItemModel({required this.id, required this.title});

    /// Server-side identifier.
    @JsonKey(name: 'id')
    final String id;

    /// User-visible title.
    @JsonKey(name: 'title')
    final String title;

    /// Parses JSON from the API into a [MyItemModel].
    factory MyItemModel.fromJson(Map<String, dynamic> json) =>
        _$MyItemModelFromJson(json);
  }
  ```

- **Data Sources (Retrofit + generated only):** Add new endpoints in `lib/base/data_sources/remote/`. You **MUST use Retrofit** to define these HTTP clients. Always add code docs to explain each endpoint.
  - **Author only the abstract API:** declare the `@RestApi()` abstract class, the `factory …(Dio dio, {String baseUrl}) = _<Name>RemoteDataSource;` redirecting constructor, method signatures, and `part '<name>_remote_data_source.g.dart';`. **Do not** hand-write a concrete data source class, `implements`/`extends` body, or per-endpoint `dio.get/post/…` code — that code is **always** produced by `build_runner` (Retrofit generator) into `*_remote_data_source.g.dart`.
  - **Never** create, edit, or paste content into `*_remote_data_source.g.dart` (or any `*.g.dart` for data sources). If the part file is missing, run `flutter pub run build_runner build --delete-conflicting-outputs` (or `bin/build_runner_build.sh`) and fix the abstract API until generation succeeds.
  - **ALWAYS** import exactly `package:dio/dio.dart` and `package:retrofit/retrofit.dart` for Retrofit data sources. Do not import any other HTTP client packages or write custom HTTP code.
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
- **Repositories:** Implement repositories in `lib/base/repositories/` to interact with data sources and provide data to services. Always add code docs to explain each method.
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

- **Services:** Create your service in `lib/feature_{new_feature_name}/services/`. Always add code docs to explain each method.
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

  **Pre-API gating (e.g. minimum search length) — in the service, not the BLoC:**

  ```dart
  const int kMyFeatureMinQueryLength = 2;

  Future<PaginatedList<MyDomainModel>> searchItems({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    final trimmed = query.trim();
    if (trimmed.length < kMyFeatureMinQueryLength) {
      return PaginatedList<MyDomainModel>(
        list: [],
        pageSize: pageSize,
        totalCount: 0,
      );
    }
    final response = await _repository.searchItems(
      q: trimmed,
      page: page,
      perPage: pageSize,
    );
    return PaginatedList<MyDomainModel>(
      list: response.items,
      pageSize: pageSize,
      totalCount: response.totalCount,
    );
  }
  ```

### 4. Generate Presentation Layer (Feature Folder)
Create a new directory `lib/feature_{new_feature_name}` and generate its architecture:

**A. BLoC (Business Logic Component)**
Create `blocs/{name}_bloc.dart`. It should rely on `rx_bloc` to handle UI events and expose streams as state. Ensure you declare the `.rxb.g.dart` generated files in this file as required by `build_runner`. Always add code docs to explain each event and state.

**Only** add a state to `…BlocStates` (and its implementations) if it is used by the feature. Do not scaffold `isLoading`, `errors`, or `data` from an example BLoC unless the new feature’s page(s) actually subscribe to them.

By default there is **one** such BLoC per feature; do not add companion BLoCs to split logic unless the user asked for a multi-BLoC design.

The **errors** state in the state contract is **always** `Stream<ErrorModel>` **when the BLoC exposes that contract**. If the UI does not consume aggregated errors, omit the getter; do not add a dead `errors` stream to satisfy a template.

*Note: The following is an example of a simple BLoC that manages state with loading and error handling:*

Read the reference implementation in `.agents/skills/create_feature/references/simple_bloc.md` for an example of a simple BLoC that manages state with loading and error handling.

**Inline compositions over throwaway locals — MANDATORY:**

Prefer composing streams **inline** inside `Rx.merge([...])`, `switchMap(...)`, `withLatestFrom(...)`, etc. Do **not** pull a one-shot composition into a `final queryRequests = ...` style local just to reference it once on the next line — it adds a naming step without improving clarity and hides the pipeline shape.

**Pagination / Infinite Scroll BLoC**

Read the reference implementation in `.agents/skills/create_feature/references/pagination_bloc.md` for an example of a BLoC that manages paginated data using the `rx_bloc_list` package.

**Pagination / Infinite Scroll with Search by Query BLoC**

Read the reference implementation in `.agents/skills/create_feature/references/pagination_with_query_bloc.md` for an example of a BLoC that manages paginated data with a search query, including debouncing and pre-API gating.

*Note: The following is an example demonstrating a BLoC that handles **form management and validation** where UI interactions flow through the BLoC.*

Read the reference implementation in `.agents/skills/create_feature/references/form_bloc.md` for an example of a BLoC that manages form state and validation.

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
Build the UI in `views/{name}_page.dart` focusing on the Figma design. If any Widget has configurable parameters, always add code docs to explain each field.

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

If the required color, typography style, spacing value, or icon is missing from the design system, **add it to the appropriate file in `lib/base/theme/design_system/` first** rather than hardcoding it at the call site.

**Icons from design system only — mandatory:**
- Every icon used by feature UI MUST be referenced from `context.designSystem.icons` (or the equivalent `DesignSystemIcons` accessor in this project).
- Do not use direct `IconData`, ad-hoc asset paths, or inline SVG/widget icon definitions in feature code.
- If a needed icon does not exist yet, add the icon asset and register it in `DesignSystemIcons`, then consume it from the design system accessor.

If the Figma design contains any icons in SVG format, import them into `assets/icons/`, update `pubspec.yaml`, and register them in `DesignSystemIcons` before using them in UI widgets.

**Adaptive scroll physics for `ListView.builder` — mandatory:**
- Every `ListView.builder` must use adaptive, framework-native scroll behavior. Prefer leaving `physics` unset so Flutter applies the correct platform defaults automatically.
- If `physics` must be set (for feature-specific behavior), derive it from centralized or framework-provided configuration (for example via `ScrollConfiguration.of(context).getScrollPhysics(context)` or a project-level scroll physics provider). Do not hardcode platform checks or platform-specific constants in feature pages/components.
- For nested scrollable layouts, explicitly configure parent/child scrolling responsibilities (for example `primary`, `shrinkWrap`, `NeverScrollableScrollPhysics` where appropriate) to avoid gesture conflicts and preserve smooth scrolling.
- Avoid performance regressions: do not enable `shrinkWrap` unless required by nesting constraints, and preserve lazy list construction semantics of `ListView.builder`.

**Reusable components — check before creating:**
Always check `lib/base/common_ui_components/` for an existing widget before building a new one. Common examples include:
- Error states → use `AppErrorWidget` (or equivalent) rather than writing a custom error view
- Loading indicators → use the project's shared loading widget
- Buttons, list tiles, avatars, empty-state views — check if they already exist
- Shared AppBar, NavBar

Only create a new widget in `feature_{name}/ui_components/` if no suitable reusable component exists. If you create something that is clearly reusable across features, place it in `lib/base/common_ui_components/` instead.

**Strings & Localisation — mandatory:**
Every user-visible string MUST go through the l10n system. Never use raw string literals in the UI.

Workflow:
1. **Extract strings from Figma** (labels, titles, button text, placeholders, error messages, etc.)
2. **Add each string to every `.arb` file** scoped to its feature as `lib/l10n/sources/feature_<name>_<languageCode>.arb` (e.g., `_en.arb`, `_de.arb`, …):
   ```json
   // feature_my_name_en.arb
   "featureMyNameTitle": "My Feature",
   "featureMyNameEmptyState": "Nothing here yet.",
   "featureMyNameRetryButton": "Retry"
   ```
3. **Run script** to merge them into the unified intl file and generate:
   ```sh
   bin/gen_l10n.sh
   ```
4. **Run code generation** so the typed accessors are created:
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   # or
   bin/build_runner_build.sh
   ```
5. **Use the generated accessors in the UI** via `context.l10n.<key>`:
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
**When** the BLoC exposes aggregated errors to the UI, use a dedicated state stream. The type **must** be `Stream<ErrorModel>` (not `String`). If the feature does not include `errors` in the state contract, do not add the getter or this wiring (paginated list BLoCs that follow the mandatory `rx_bloc_list` pattern are an exception and still require `errors` as documented there).

Example (when exposing errors):

```dart
/// The error state
Stream<ErrorModel> get errors;
```

The `ErrorModel` can be mapped to appropriate UI representation using `error_model_extensions.dart` and `mapToErrorModel()` on `errorState`.

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

- **Code Generation:** Run code generation so **Retrofit data source implementations** (`*_remote_data_source.g.dart`) and other generated code (JsonSerializable, RxBloc) exist — they are not written by hand:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
  Or simply run `bin/build_runner_build.sh`.
- **Dart import/symbol hygiene (mandatory):** For every modified Dart file, verify unresolved identifiers/imports are clean.
- Update project-specific documentation if necessary (e.g., README, architecture docs, AGENTS.md etc.)

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

- **NEVER** add a BLoC state stream (`get` in the states class or the corresponding `_*mapTo…` implementation) that is **not** read from the feature UI, a feature test, or an implemented non-UI consumer — no unused “template” states
- **NEVER** create a BLoC without the corresponding `.rxb.g.dart` part directive
- **NEVER** split a feature into two or more feature-scoped BLoCs for “clean separation” when the user did not ask for multiple BLoCs — use one BLoC and multiple events/streams
- **NEVER** instantiate services or repositories directly in BLoCs — use dependency injection
- **NEVER** put business logic in the UI layer (pages/widgets)
- **NEVER** call APIs directly from BLoCs — use services and repositories
- **NEVER** hand-implement remote data source classes (no manual `Dio` calls, no concrete `*RemoteDataSource` with `@override` methods, no stub `*.g.dart` bodies) — add or extend the **abstract** Retrofit API only, then run `build_runner` so `*_remote_data_source.g.dart` is **generated** (Dio/Retrofit imports only on the authored API file, per project conventions)
- **NEVER** implement pre-API gating or short-circuits in the BLoC (minimum query length, empty-query empty list, etc.) — put that logic in the service
- **NEVER** skip error handling with `ErrorMapper` in repositories
- **NEVER** hardcode strings — use localization keys
- **NEVER** create routes without registering them in the router
- **NEVER** use `setState` in pages — use BLoC states instead
- **NEVER** create feature-specific models in `lib/base/models/` — put them in `lib/feature_<name>/models/`
- **NEVER** use hardcoded colors, font sizes, font weights, spacing/padding values, or icons — always use `context.designSystem.*`; if the value doesn't exist yet, add it to `lib/base/theme/design_system/`
- **NEVER** use icons directly from `Icons.*`, raw `SvgPicture.asset(...)`, or feature-local icon constants in page/UI component code; icons must come from `context.designSystem.icons` and missing icons must be added to `DesignSystemIcons` first
- **NEVER** hardcode `ListView.builder` physics with platform branches in feature code (e.g., `Platform.isIOS ? BouncingScrollPhysics() : ClampingScrollPhysics()`) — use framework defaults or centralized scroll configuration
- **NEVER** set `shrinkWrap: true` on `ListView.builder` unless the list is nested and requires it; unnecessary shrink-wrapping hurts scroll performance
- **NEVER** declare BLoC aggregated errors as `Stream<String>`, `ConnectableStream<String>`, or map `errorState` with `toString()` for the main errors state — use `Stream<ErrorModel>` and `errorState.mapToErrorModel()`
- **NEVER** write a custom error, loading, or empty-state widget without first checking `lib/base/common_ui_components/` for an existing one
- **NEVER** use raw string literals in the UI — every user-visible string must be an l10n key in the `.arb` files and accessed via `context.l10n.<key>`
- **NEVER** back internal BLoC state with plain fields (`String _foo = ''`, `bool _isDirty = false`, …) — use `BehaviorSubject<T>.seeded(...)` (or `ReplaySubject`/`PublishSubject` where appropriate) and `.close()` every owned subject in `dispose()` before `super.dispose()`
- **NEVER** extract a one-shot stream composition into a local variable just to reference it once downstream (`final queryRequests = ...; Rx.merge([queryRequests, ...])`) — compose inline inside `Rx.merge([...])`, `switchMap(...)`, `withLatestFrom(...)`, etc., so the pipeline shape is visible at a glance; only extract when the same composition is consumed by two or more downstream operators, and in that case prefer a named method or extension
- **NEVER** make a local StatefulWidget variable which refreshes itself by listening to a Bloc value. The only way to consume them should be the `Rx*` Widgets; ONLY use StatefulWidget in case complicated UI calculations are really necessary (animations etc.)

## Reference: Key Import Paths

### In BLoC files:

```dart
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../services/<name>_service.dart';

part '<name>_bloc.rxb.g.dart';
```

(Include `ErrorModel` / `error_model_extensions` whenever the BLoC exposes `Stream<ErrorModel> get errors` for aggregated `errorState` wiring; if the feature does not expose `errors`, omit these imports.)

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

The same applies when it is unclear whether the user wants **one** feature BLoC (default) or an explicit **multi-BLoC** setup — ask before creating more than one feature-scoped `RxBloc`.

By following these architecture guidelines strictly, you will produce seamless, clean, scalable features fully integrated into the project.

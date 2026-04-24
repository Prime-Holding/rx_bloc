---
description: Create a new feature in the Flutter project - Complete feature scaffolding including data layer, business logic, presentation layer, and routing
---

# Create a New Feature

This skill guides the AI agent in creating a new feature in the Flutter project, adhering strictly to the established architecture and RxBloc patterns.

> **Reference implementation:** `lib/feature_profile/` and `lib/feature_accounts/` — these are canonical examples

## Non-negotiable: model documentation

For every new or changed hand-written model (under `lib/base/models/**` or `lib/feature_{name}/models/**`):

- **MUST** add `///` for every public class, enum, mixin, extension, typedef, top-level declaration, field, constructor, and enum value when the name is not self-explanatory.

## Non-negotiable: BLoC error / errors state

**When** the BLoC state contract exposes an aggregated error stream, it **MUST** be typed as:

- `Stream<ErrorModel> get errors` (or `get error` if the feature uses a singular name — the type is always `ErrorModel`, never `String` or `Object`).

Wire it with `errorState.mapToErrorModel()` (typically in `_mapToErrorsState()` or an `@override` of the generated errors getter), and import `../../base/models/errors/error_model.dart` plus `../../base/extensions/error_model_extensions.dart` as in the BLoC examples in this document. If the feature UI does not need aggregated errors, **do not** add an `errors` stream just to follow a template (see **Non-negotiable: BLoC state contract is minimal and wired**).

**Do not** expose `Stream<String>`, `ConnectableStream<String>`, or `errorState.map((e) => e.toString())` for the primary BLoC error stream — the UI translates via `ErrorModel` (e.g. `error.translate(context)`).

## Non-negotiable: BLoC state contract is minimal and wired

In `abstract class …BlocStates` (and the corresponding `_*mapTo…State` / `get` implementations), you **MUST** only declare state streams that have a real consumer.

**What counts as “used” (at least one must apply):**

- The feature’s **UI** subscribes (e.g. `RxBlocBuilder`, `RxPaginatedBuilder`, `RxTextFormFieldBuilder`, `RxResultBuilder`, or passing `bloc.states.<name>` to a `Stream` sub-widget).
- The feature’s **unit tests** assert on the stream, **or**
- A **documented** integration (another BLoC, `CoordinatorBloc`, or router) is intended and implemented in the same change.

**MUST NOT:**

- Add `Stream<T> get …` (including `@RxBlocIgnoreState()` “aggregate” states like `isLoading` or `errors`) that nothing reads — copy-pasting example blocks and leaving extra getters is a defect.
- Add placeholder states “for later” or to mirror a reference BLoC line-by-line when the feature’s screens do not need them.
- Duplicate information that is already expressible through another state. If a state’s data (or a combination of existing states) is enough to infer what the screen or tests need, **use that state** instead of introducing a new stream. For example, on a paginated page, a failed load is already covered by the aggregated `errors` stream and the current paginated result; **do not** add separate states for “last execution time”, “query at failure”, or similar unless something truly subscribes to those values in isolation and they cannot be derived from the existing contract.

**Prefer deriving over duplicating:** when the same fact can be read from streams you already expose, do that in the feature UI (e.g. one builder or listener that has what it needs) instead of persisting a parallel copy in BLoC state.

If the UI does not need loading or aggregated errors, **omit** those getters; do not generate them “just in case.”

**Exception — paginated `rx_bloc_list` BLoC:** A BLoC that follows **Pagination / Infinite Scroll BLoC — MANDATORY wiring** must still declare `isLoading` and `errors` exactly as that subsection requires. Those streams are not optional there: they are part of the required contract for that pattern (aggregated `loadingState` / `errorState` with `setResultStateHandler`). The feature view should still use them where appropriate (e.g. `RxBlocListener` for errors) or they remain available for tests — do not delete them in the name of minimal state.

## Non-negotiable: one BLoC per feature (default)

Unless the user **explicitly** asks to split the feature across multiple BLoCs (e.g. separate search coordinator + list BLoC, or list + details with separate blocs by name), you **MUST** create **exactly one** feature BLoC (typically `blocs/{feature}_bloc.dart`) and keep **all** feature business logic, stream composition, and UI-driven events in that single class.

- **Do not** add extra feature-scoped BLoCs to separate “search vs list”, “form vs fetch”, or similar concerns by default — model those as separate **events and state streams** inside the one BLoC.
- **Exception:** The app-wide `CoordinatorBloc` (and other global blocs) are not “feature BLoCs”; injecting them is fine and does not count as splitting a feature into multiple BLoCs.
- If the user later asks to refactor into multiple BLoCs, treat that as a new requirement — do not preemptively multi-BLoC a feature during initial scaffolding.

## Non-negotiable: service owns pre-API gating and short-circuits

Any business rule that decides **whether** to call the data layer (remote API, local store, or other I/O) for a given request **MUST** live in the feature **Service** (`lib/feature_{name}/services/`), not in the BLoC. The service is where **domain- and product-specific** logic lives: eligibility, preconditions, validity, ranges, and other rules that can be satisfied *without* touching the repository.

Typical **short-circuits** the service may apply (as required by the feature) include: returning an empty or default `PaginatedList` / `Result` when the current inputs or state are not yet suitable for a real fetch, or when the product rules say the outcome is known up front. The BLoC must not duplicate that reasoning.

**MUST:**

- Implement the predicate and the short-circuit return value **in the same service method** that would otherwise call the repository, so the decision to skip I/O and the value returned to the caller are defined in one place
- Expose any `const` **limits, thresholds, or other values** the **view** needs for copy, labels, or inline hints (validation messaging, "minimum N…", and similar) in the **same** service file or a small feature-local constants module, and have the view import from there — the BLoC **must not** own those constants

**BLoC:**

- **MUST NOT** reimplement eligibility, validation, or "should we load?" rules in the presentation layer (e.g. inside `switchMap`, on page-load event pipelines, or by constructing empty `PaginatedList` / `Result` in place of calling the service). **Always** call the service; only the service decides whether I/O runs.

**Pairing (pagination):** A paginated list BLoC still calls the same `service.…` entry point on every `loadPage`; the service method returns an empty or appropriately shaped `PaginatedList` when gating rules apply, using the same `pageSize` the BLoC uses.

## Inputs Required

To successfully execute this skill, the following inputs MUST be provided:
1. **Feature name:** The name for the new feature (e.g., `transfer_history`, `card_details`)
2. **Figma Link (optional, using MCP):** The design file containing the UI layout, colors, typography, and intended interactions for the new feature. If any Figma links are provided, they MUST be read using Figma MCP.
3. **Swagger (Open API) Specification (optional):** The API documentation defining the needed API endpoints, request models, and response models.
4. **Multiple BLoCs (optional, explicit only):** If the user wants more than one feature-scoped BLoC, they must say so — otherwise the agent follows **Non-negotiable: one BLoC per feature (default)**.

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
- [ ] Unless the user explicitly requested multiple feature BLoCs, plan **one** BLoC for the feature — see **Non-negotiable: one BLoC per feature (default)**
- [ ] Identify which BLoC pattern to use (list, details, or manage)
- [ ] For that BLoC, list **only** the state streams the page(s) will **actually** subscribe to (see **Non-negotiable: BLoC state contract is minimal and wired**); do not add unused states to mirror examples
- [ ] If the feature includes a **paginated or infinite-scroll list** (`rx_bloc_list`), that **single** feature BLoC **MUST** implement the list with the **exact** wiring in **"Pagination / Infinite Scroll BLoC — MANDATORY wiring"** later in this document — no alternate event shapes, merge-based page triggers, or shortened pipelines; **pre-API gating** (min query length, empty input, etc.) **MUST** be implemented in the service, not the BLoC (**Non-negotiable: service owns pre-API gating and short-circuits**)
- [ ] Build an execution plan, save it inside `lib/feature_{name}/` as `PLAN.md` and ask the user to review it before proceeding with execution.

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

- **Data Sources:** Add new endpoints in `lib/base/data_sources/remote/`. You **MUST use Retrofit** to define these HTTP clients. Always add code docs to explain each endpoint.
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

  See **Non-negotiable: service owns pre-API gating and short-circuits**.

### 4. Generate Presentation Layer (Feature Folder)
Create a new directory `lib/feature_{new_feature_name}` and generate its architecture:

**A. BLoC (Business Logic Component)**
Create `blocs/{name}_bloc.dart`. It should rely on `rx_bloc` to handle UI events and expose streams as state. Ensure you declare the `.rxb.g.dart` generated files in this file as required by `build_runner`. Always add code docs to explain each event and state.

**Only** add a state to `…BlocStates` (and its implementations) if it is used by the feature (see **Non-negotiable: BLoC state contract is minimal and wired**). Do not scaffold `isLoading`, `errors`, or `data` from an example BLoC unless the new feature’s page(s) actually subscribe to them.

By default there is **one** such BLoC per feature (see **Non-negotiable: one BLoC per feature (default)**); do not add companion BLoCs to split logic unless the user asked for a multi-BLoC design.

The **errors** state in the state contract is **always** `Stream<ErrorModel>` **when the BLoC exposes that contract** (see **Non-negotiable: BLoC error / errors state** and **Non-negotiable: BLoC state contract is minimal and wired** above). If the UI does not consume aggregated errors, omit the getter; do not add a dead `errors` stream to satisfy a template.

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

**Internal State via Subjects — MANDATORY:**

Whenever a BLoC needs to remember a value between events (last query, current failure scope, flag, counter, model, …), back it with a **stream-shaped container** rather than a plain field.

- Use `BehaviorSubject<T>.seeded(initial)` for single latest values, `ReplaySubject<T>` for short histories, `PublishSubject<T>` for one-shot notifications. Default to `BehaviorSubject` for state.
- Mutate via `.add(...)`; read the current value via `.value` (for `BehaviorSubject`) only when strictly necessary — prefer composing the subject with `rxdart` operators (`withLatestFrom`, `switchMap`, `distinctUnique`, `scan`, …) from inside `_mapTo...State` pipelines.
- Expose the subject externally only through a `Stream<T>` getter, typically wired with `@RxBlocIgnoreState()`; never leak the `BehaviorSubject` itself through the state contract.
- **Every subject the BLoC owns MUST be `.close()`d in `dispose()` before `super.dispose()`**.

```dart
final _lastEvaluatedQuerySubject = BehaviorSubject<String>.seeded('');
final _hasPendingChangesSubject = BehaviorSubject<bool>.seeded(false);

// State overridden with @RxBlocIgnoreState()
@override
Stream<String> get lastEvaluatedQuery =>
        _lastEvaluatedQuerySubject.distinct();

@override
Stream<bool> _mapToCanSubmitState() => _hasPendingChangesSubject
        .distinct()
        .shareReplay(maxSize: 1);

@override
void dispose() {
  _lastEvaluatedQuerySubject.close();
  _hasPendingChangesSubject.close();
  super.dispose();
}
```

Plain fields (`String _foo = ''`, `bool _isDirty = false`, `MyModel? _lastModel`) are an anti-pattern for BLoC state: downstream pipelines cannot react to them, tests cannot observe their transitions, and disposal semantics get fuzzy. Convert them to `BehaviorSubject`s.

**Inline compositions over throwaway locals — MANDATORY:**

Prefer composing streams **inline** inside `Rx.merge([...])`, `switchMap(...)`, `withLatestFrom(...)`, etc. Do **not** pull a one-shot composition into a `final queryRequests = ...` style local just to reference it once on the next line — it adds a naming step without improving clarity and hides the pipeline shape.

> **Pagination / `rx_bloc_list` carve-out (non-negotiable):** The examples below illustrate **generic** multi-trigger pipelines (e.g. search + auxiliary reload). They **do not** apply to infinite-scroll list BLoCs. For paginated lists, **only** the subsection **"Pagination / Infinite Scroll BLoC — MANDATORY wiring"** is authoritative — you **must not** merge extra streams into `_$loadPageEvent`, add a separate `retry` / `loadNext` / `refresh` event for paging, or wrap the mandatory chain with `throttleTime`, `debounceTime`, `exhaustMap`, or `Rx.merge` before `switchMap`. Search-query debouncing belongs in a **separate event pipeline in the same (single) feature BLoC** (default) that calls `loadPage(reset: true)` — not on `_$loadPageEvent` itself. **Only** if the user explicitly requested multiple feature BLoCs may you use a second BLoC for search that forwards to the list BLoC.

```dart
// PREFERRED: the shape of the pipeline is visible at a glance.
// (Illustrative only — not for rx_bloc_list pagination; see mandatory wiring below.)
return Rx.merge<_FetchRequest>([
_$setSearchQueryEvent
        .map((q) => q.trim())
        .debounceTime(const Duration(milliseconds: 350))
        .distinct()
        .map(_QueryRequest.new),
Rx.merge<bool>([
_$reloadEvent,
_$retryLastFetchEvent.map((_) => _lastFailureScope != _FailureScope.append),
]).throttleTime(kBackpressureDuration).map(_AuxiliaryFetchRequest.new),
]).switchMap(_handleRequest).setResultStateHandler(this); // ...
```

```dart
// AVOID: temporary locals used only once downstream.
final queryRequests = _$setSearchQueryEvent
        .map((q) => q.trim())
        .debounceTime(const Duration(milliseconds: 350))
        .distinct()
        .map(_QueryRequest.new);

final auxiliaryRequests = Rx.merge<bool>([
  _$reloadEvent,
  _$retryLastFetchEvent.map((_) => _lastFailureScope != _FailureScope.append),
]).throttleTime(kBackpressureDuration).map(_AuxiliaryFetchRequest.new);

return Rx.merge([queryRequests, auxiliaryRequests]).switchMap(_handleRequest)...;
```

Only extract a local when the **same** composition is consumed by two or more downstream operators (e.g. a `publish()`ed stream used both to drive a request and to refresh a UI signal) — and in that case, consider lifting it to a named method or extension instead.

**Pagination / Infinite Scroll BLoC — MANDATORY wiring:**

When the feature requires a paginated list or infinite scroll, the BLoC **MUST** follow the exact pattern below. This is not an illustrative example — it is the required wiring. This subsection **overrides** the generic "Inline compositions" guidance above and any other BLoC examples in this document for **page loading** behavior. The agent MUST NOT invent alternative event names, alternative operators, alternative state shapes, or omit any of the listed elements. Deviations will break `rx_bloc_list` integration and `CoordinatorBloc` merging in downstream features.

**Explicitly forbidden (pagination BLoCs):**

- Any event other than `void loadPage({bool reset = false})` that triggers a page fetch (`refresh`, `loadNext`, `retryLastFetch`, etc.)
- Merging `_$loadPageEvent` with other streams, or replacing `startWith(true)` with a different seeding strategy, before the mandated `switchMap`
- Inserting `throttleTime`, `debounceTime`, `exhaustMap`, or `Rx.merge` on the `_$loadPageEvent` pipeline (move backpressure/debounce to another event pipeline in the **same** feature BLoC that calls `loadPage`, or — only if the user asked for multiple BLoCs — a separate coordinator BLoC)
- Skipping `CoordinatorBlocType` injection, `setResultStateHandler`, `mergeWithPaginatedList`, `bind`, or `addTo(_compositeSubscription)` in the constructor chain
- Using `Stream<List<T>>` or `Result<PaginatedList<T>>` as the canonical list state instead of `Stream<PaginatedList<T>> get paginatedList`

Required elements (all are mandatory — do not drop or rename any):

- [ ] Import `package:rx_bloc_list/rx_bloc_list.dart` and `package:rxdart/rxdart.dart`
- [ ] Import `CoordinatorBloc` from `../../base/common_blocs/coordinator_bloc.dart` and inject `CoordinatorBlocType` (even if unused at first — paginated lists almost always need to react to cross-BLoC updates)
- [ ] Declare a single event: `void loadPage({bool reset = false})` — do NOT add separate `refresh`/`loadNext` events; the `reset` flag covers both
- [ ] Expose `Stream<PaginatedList<T>> get paginatedList` as the canonical list state
- [ ] Expose `Stream<bool> get isLoading` and `Stream<ErrorModel> get errors` — both MUST be annotated with `@RxBlocIgnoreState()` and wired to `loadingState` and `errorState.mapToErrorModel()` (the aggregated loading stream from rx_bloc; errors as structured `ErrorModel`, never `String`)
- [ ] Hold the list in a `BehaviorSubject<PaginatedList<T>>.seeded(...)` with an initial empty `PaginatedList` that specifies `pageSize` and `totalCount: 0`
- [ ] Wire the event chain in the constructor exactly as: `_$loadPageEvent.startWith(true).switchMap(...).setResultStateHandler(this).mergeWithPaginatedList(_paginatedList).bind(_paginatedList).addTo(_compositeSubscription)`
- [ ] On `reset == true`, call `_paginatedList.value.reset()` BEFORE issuing the fetch
- [ ] Fetch the next page via `page: _paginatedList.value.pageNumber + 1` and `pageSize: _paginatedList.value.pageSize` — never hardcode page numbers
- [ ] Convert the future to a result stream using `.asResultStream()` inside the `switchMap`
- [ ] Override `dispose()` to call `_paginatedList.closeSafely()` before `super.dispose()`

Use this as the starting scaffold (replace `MyDomainModel` and class names; keep everything else intact):

  ```dart
  import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../services/my_feature_service.dart';

part 'my_feature_bloc.rxb.g.dart';

/// A contract class containing all events of the MyFeatureBloC.
abstract class MyFeatureBlocEvents {
  /// Triggers a fetch operation for the next page of items.
  ///
  /// When [reset] is `true`, the internal paginated list is reset to page 0
  /// before the fetch, effectively reloading the list from the beginning.
  void loadPage({bool reset = false});
}

/// A contract class containing all states of the MyFeatureBloC.
abstract class MyFeatureBlocStates {
  /// The resulting state stream of the fetched paginated data.
  Stream<PaginatedList<MyDomainModel>> get paginatedList;

  /// The aggregated loading state for the list.
  @RxBlocIgnoreState()
  Stream<bool> get isLoading;

  /// The aggregated error state for the list.
  @RxBlocIgnoreState()
  Stream<ErrorModel> get errors;
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
  Stream<ErrorModel> get errors => errorState.mapToErrorModel();

  @override
  void dispose() {
    _paginatedList.closeSafely();
    super.dispose();
  }
}
  ```

**Agent completion gate (paginated list features):**

Before finishing implementation or telling the user the feature is done, the agent **MUST** walk the **Required elements** checklist above line-by-line against the generated `*_bloc.dart` and fix any mismatch. A single deviation (wrong event name, missing import, extra operator on `_$loadPageEvent`, wrong `dispose`, etc.) is a **blocking** defect.

**Pairing requirements for paginated BLoCs:**

- The service layer MUST expose a `Future<PaginatedList<T>> fetchPaginatedData({int page, int pageSize})` (or `search…` with `query` + `page` + `pageSize`, etc.) method — see the "infinite scroll capabilities service example" in section 3. The service MUST own any pre-API gating (**Non-negotiable: service owns pre-API gating and short-circuits**).
- The view layer MUST consume `paginatedList` using `RxPaginatedBuilder` (or an equivalent from `rx_bloc_list`) and trigger `loadPage(reset: true)` on pull-to-refresh and `loadPage()` on scroll-to-end.
- If the feature participates in cross-BLoC updates (item added / updated / deleted elsewhere), merge `_coordinatorBloc.states.on*` streams into `_paginatedList` using the appropriate `rx_bloc_list` merge operators — do NOT call `loadPage(reset: true)` as a shortcut for refreshing a single item.

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

If the required color, typography style, spacing value, or icon is missing from the design system, **add it to the appropriate file in `lib/base/theme/design_system/`** rather than hardcoding it at the call site.

If the Figma design contains any icons in SVG format, import them into '/assets/icons/' as well as pubspec.yaml, and add them to DesignSystemIcons before using them inside the UI widgets.

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
   "title": "My Feature",
   "emptyState": "Nothing here yet.",
   "retryButton": "Retry"
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
**When** the BLoC exposes aggregated errors to the UI, use a dedicated state stream. The type **must** be `Stream<ErrorModel>` (not `String`). If the feature does not include `errors` in the state contract, do not add the getter or this wiring (see **Non-negotiable: BLoC state contract is minimal and wired** — paginated list BLoCs that follow the mandatory `rx_bloc_list` pattern are an exception and still require `errors` as documented there).

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

- **Code Generation:** Run code generation commands to generate Retrofit, JsonSerializable, and RxBloc files:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
  Or simply run `bin/build_runner_build.sh`.

### 6. Testing

After creating the feature, tests MUST always be created following the project's testing patterns:

- **Unit Tests:** Create unit tests for services and BLoCs in `test/feature_<name>/`, by invoking the `unit_test` skill with `feature_<name>`
- **Golden Tests:** Create golden tests for pages in `test/feature_<name>/view/`, by invoking the `golden_test` skill with `feature_<name>`

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

- **NEVER** add a BLoC state stream (`get` in the states class or the corresponding `_*mapTo…` implementation) that is **not** read from the feature UI, a feature test, or an implemented non-UI consumer — no unused “template” states (see **Non-negotiable: BLoC state contract is minimal and wired**)
- **NEVER** create a BLoC without the corresponding `.rxb.g.dart` part directive
- **NEVER** split a feature into two or more feature-scoped BLoCs for “clean separation” when the user did not ask for multiple BLoCs — use one BLoC and multiple events/streams (see **Non-negotiable: one BLoC per feature (default)**)
- **NEVER** instantiate services or repositories directly in BLoCs — use dependency injection
- **NEVER** put business logic in the UI layer (pages/widgets)
- **NEVER** call APIs directly from BLoCs — use services and repositories
- **NEVER** implement pre-API gating or short-circuits in the BLoC (minimum query length, empty-query empty list, etc.) — put that logic in the service; see **Non-negotiable: service owns pre-API gating and short-circuits**
- **NEVER** skip error handling with `ErrorMapper` in repositories
- **NEVER** hardcode strings — use localization keys
- **NEVER** create routes without registering them in the router
- **NEVER** use `setState` in pages — use BLoC states instead
- **NEVER** create feature-specific models in `lib/base/models/` — put them in `lib/feature_<name>/models/`
- **NEVER** use hardcoded colors, font sizes, font weights, spacing/padding values, or icons — always use `context.designSystem.*`; if the value doesn't exist yet, add it to `lib/base/theme/design_system/`
- **NEVER** declare BLoC aggregated errors as `Stream<String>`, `ConnectableStream<String>`, or map `errorState` with `toString()` for the main errors state — use `Stream<ErrorModel>` and `errorState.mapToErrorModel()` (see **Non-negotiable: BLoC error / errors state**)
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

(Include `ErrorModel` / `error_model_extensions` whenever the BLoC exposes `Stream<ErrorModel> get errors` for aggregated `errorState` wiring per **Non-negotiable: BLoC error / errors state**; if the feature does not expose `errors`, omit these imports.)

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

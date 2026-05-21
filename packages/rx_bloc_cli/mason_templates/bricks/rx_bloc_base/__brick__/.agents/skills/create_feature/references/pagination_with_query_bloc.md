Use this as the starting scaffold (replace `MyDomainModel` and class names; keep the pipeline shape intact).

## Consistency checklist (read before coding)
1. **Query source of truth** — For `@RxBlocEvent(type: RxBlocEventType.behaviour) void setSearchQuery(String query)`, the generator backs the event with a **`BehaviorSubject<String>`** (`_$setSearchQueryEvent`). **Do not** add a second `BehaviorSubject<String>` just to hold the latest text; that duplicates the same fact and drifts from the reference. Read the current query from **`_$setSearchQueryEvent`** when wiring the service call.
2. **`PaginatedList` holder** — Pipe **`mergeWithPaginatedList(_paginatedList).bind(_paginatedList)`** so the merged `Result` stream is the only writer to that subject—**avoid** manually mirroring with `.doOnData(_paginatedListSubject.add)`. Expose state with **`_mapToPaginatedListState() => _paginatedList`** (the subject is a `Stream`).
3. **Avoid extra UI-only state streams** — Do not add `@RxBlocIgnoreState() Stream<String> get searchTrim`. Prefer: keep the text field as the visual source of truth, and drive empty / “too short” copy from **`PaginatedList`** plus **service-side gating** (empty list, `totalCount: 0`) and/or a single paginated state. Fewer streams means fewer `RxBlocBuilder` subscriptions and less desync.
4. **Pre-API gating** — Keep minimum query length / empty-query short-circuit in the **service**, not the BLoC (see `SKILL.md`).
---

## Reference scaffold

```dart
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

import '../app/config/app_constants.dart';
import '../services/my_feature_service.dart';

part 'my_feature_bloc.rxb.g.dart';

/// A contract class containing all events of the MyFeatureBloC.
abstract class MyFeatureBlocEvents {
  /// Updates the live search text; debounced before triggering a fetch.
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void setSearchQuery(String query);

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
}

@RxBloc()
class MyFeatureBloc extends $MyFeatureBloc {
  MyFeatureBloc(this._service) {
    Rx.merge([
      _$setSearchQueryEvent
          .map((q) => q.trim())
          .debounceTime(kBackpressureDuration)
          .distinct()
          .map((_) => true),
      _$loadPageEvent,
    ])
        .startWith(true)
        .switchMap((reset) {
          if (reset) _paginatedList.value.reset();

          return _service
              .fetchPaginatedData(
                query: _$setSearchQueryEvent.value,
                page: _paginatedList.value.pageNumber + 1,
                pageSize: _paginatedList.value.pageSize,
              )
              .asResultStream();
        })
        .setResultStateHandler(this)
        .mergeWithPaginatedList(_paginatedList)
        .bind(_paginatedList)
        .addTo(_compositeSubscription);
  }

  final MyFeatureService _service;

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
  void dispose() {
    _paginatedList.close();
    super.dispose();
  }
}
  ```
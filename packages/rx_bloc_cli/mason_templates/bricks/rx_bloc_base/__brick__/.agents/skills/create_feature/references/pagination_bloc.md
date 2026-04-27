Use this as the starting scaffold (replace `MyDomainModel` and class names; keep everything else intact):

```dart
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

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
}

@RxBloc()
class MyFeatureBloc extends $MyFeatureBloc {
  MyFeatureBloc(
          this._service,
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
    // Merge the data in the _paginatedList
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
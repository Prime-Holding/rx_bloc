import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

mixin RxBlocListMixin<T> {
  /// region Methods

  Stream<bool> get loadPageEvent;

  StreamSubscription<bool> bindPagination() => loadPageEvent
      .startWith(true)
      .switchMap((reset) => loadPaginatedList(reset: reset).asStream())
      .bind(_refreshSubject);

  /// Method for fetching data from repository
  Future<List<T>> fetchPaginatedList({required int page});

  Future<bool> loadPaginatedList({bool reset = false}) => _loadListData(reset);

  /// Streams changes in data
  Stream<List<T>> get paginatedList => _paginatedDataSubject;

  Stream<bool> get refreshDone => _refreshSubject;

  /// Disposes of internal streams
  void disposeRxBlocListMixin() {
    _paginatedDataSubject.close();
    _refreshSubject.close();
  }

  /// endregion

  /// region Fields

  int _loadedPages = 0;
  List<T> _localData = [];
  final _paginatedDataSubject = BehaviorSubject<List<T>>.seeded([]);
  final _refreshSubject = BehaviorSubject<bool>.seeded(false);

  /// endregion

  /// region Private methods

  Future<bool> _loadListData([bool reset = false]) async {
    try {
      final data =
          reset ? await _onRefreshData() : await _fetchPageData(_loadedPages);
      _updateData(data, replace: reset);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<T>> _fetchPageData(int page) async {
    if (page < 0) page = 0;

    final fetchedData = await fetchPaginatedList(page: page);

    _loadedPages = page + 1;
    return fetchedData;
  }

  Future<List<T>> _onRefreshData() async {
    final newData = <T>[];

    // When refreshing data, start from the very first page
    _loadedPages = 0;

    final tmp = await _fetchPageData(_loadedPages);
    if (tmp.isNotEmpty) newData.addAll(tmp);

    return newData;
  }

  bool _updateData(List<T> newData, {bool replace = false}) {
    if (replace)
      _localData = newData;
    else
      _localData.addAll(newData);

    _paginatedDataSubject.add(_localData);
    return true;
  }

  /// endregion
}

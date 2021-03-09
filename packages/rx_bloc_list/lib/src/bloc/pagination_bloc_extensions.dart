part of 'pagination_bloc.dart';

extension _PaginationBlocExtensions<T> on PaginationBloc<T> {
  Future<List<T>> _fetchPageData(int page) async {
    if (page < 0) page = _loadedPages;

    final fetchedData = await _dataRepo.fetchPage(page);

    _loadedPages = page + 1;
    return fetchedData;
  }

  Future<List<T>> _onRefreshData() async {
    final List<T> newData = [];

    // Make sure that we get at least one page of data
    if (_loadedPages == 0) _loadedPages = 1;

    _refreshSubject.add(false);

    for (int i = 0; i < _loadedPages; i++) {
      final tmp = await _fetchPageData(i);
      if (tmp.isNotEmpty) newData.addAll(tmp);
    }

    _refreshSubject.add(true);

    return newData;
  }

  bool _updateData(List<T> newData, {bool replace = false}) {
    if (replace)
      _localData = newData;
    else
      _localData.addAll(newData);

    // TODO: Update entries based on their indexes

    _dataSubject.add(_localData);
    return true;
  }
}

extension _PublishSubjectVoidExtensions on PublishSubject<void> {
  Stream<bool> _refreshLoadedData<T>(PaginationBloc<T> bloc) => this
      .switchMap((_) => bloc._onRefreshData().asStream())
      .map((data) => bloc._updateData(data, replace: true));
}

extension _PublishSubjectIntExtensions on PublishSubject<int> {
  Stream<bool> _loadDataFromPage<T>(PaginationBloc<T> bloc) => this
      .switchMap((pageToLoad) => bloc._fetchPageData(pageToLoad).asStream())
      .map((fetchedData) => bloc._updateData(fetchedData));
}

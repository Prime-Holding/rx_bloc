import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rx_bloc_list/src/data_repository_interface.dart';
import 'package:rxdart/rxdart.dart';

part 'pagination_bloc.rxb.g.dart';

abstract class PaginationBlocEvents {
  // Loads next page of data. If reset is set to true, the first page is refreshed.
  void loadPage({bool reset = false});
}

abstract class PaginationBlocStates<T> {
  @RxBlocIgnoreState()
  Stream<List<T>> get paginatedList;

  @RxBlocIgnoreState()
  Stream<bool> get refreshDone;
}

@RxBloc()
class PaginationBloc<T> extends $PaginationBloc with RxBlocListMixin<T> {
  PaginationBloc(this._dataRepo) {
    bindPagination().disposedBy(_compositeSubscription);
  }

  final DataRepositoryInterface<T> _dataRepo;

  @override
  Stream<bool> get loadPageEvent => _$loadPageEvent;

  @override
  Future<List<T>> fetchPaginatedList({required int page}) =>
      _dataRepo.fetchPage(page);

  @override
  void dispose() {
    super.dispose();
    disposeRxBlocListMixin();
  }
}

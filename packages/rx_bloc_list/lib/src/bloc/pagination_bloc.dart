import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/src/interfaces/data_repository_interface.dart';
import 'package:rxdart/rxdart.dart';

part 'pagination_bloc.rxb.g.dart';
part 'pagination_bloc_extensions.dart';

abstract class PaginationBlocEvents {
  // Triggers a new data refresh
  void refreshData();

  // Loads data from a specific page. If set as -1, it loads next page.
  void load([int page = -1]);
}

abstract class PaginationBlocStates<T> {
  @RxBlocIgnoreState()
  Stream<bool> get refreshDone;

  @RxBlocIgnoreState()
  Stream<List<T>> get data;
}

@RxBloc()
class PaginationBloc<T> extends $PaginationBloc {
  PaginationBloc(
    this._dataRepo, {
    this.dataFilter,
    List<T> initialData = const [],
  })  : _localData = initialData,
        _dataSubject = BehaviorSubject<List<T>>.seeded(initialData) {
    _$refreshDataEvent
        ._refreshLoadedData(this)
        .bind(_refreshSubject)
        .disposedBy(_subscriptions);

    _$loadEvent
        ._loadDataFromPage(this)
        .asResultStream()
        .setResultStateHandler(this)
        .whereSuccess();
  }

  List<T> _localData;
  int _loadedPages = 0;

  final List<T> Function(List<T>)? dataFilter;
  final DataRepositoryInterface<T> _dataRepo;
  final BehaviorSubject<List<T>> _dataSubject;
  final _refreshSubject = BehaviorSubject<bool>.seeded(false);
  final _subscriptions = CompositeSubscription();

  @override
  void dispose() {
    super.dispose();
    _dataSubject.close();
    _refreshSubject.close();
    _subscriptions.dispose();
  }

  @override
  Stream<List<T>> get data => _dataSubject;

  @override
  Stream<bool> get refreshDone => _refreshSubject;
}

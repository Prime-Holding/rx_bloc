import 'package:example/models/dummy.dart';
import 'package:example/repositories/dummy_repository.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

part 'user_bloc.rxb.g.dart';

/// A contract class containing all events of the UserBloC.
abstract class UserBlocEvents {
  void loadPage({bool reset = false});
}

/// A contract class containing all states of the UserBloC.
abstract class UserBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  Stream<PaginatedList<Dummy>> get paginatedList;

  @RxBlocIgnoreState()
  Future<bool> get refreshDone;
}

@RxBloc()
class UserBloc extends $UserBloc {
  final _paginatedList = BehaviorSubject<PaginatedList<Dummy>>.seeded(
    PaginatedList<Dummy>(
      list: [],
      pageSize: 50,
    ),
  );

  UserBloc({required DummyRepository repository}) {
    _$loadPageEvent
        .startWith(true)
        .switchMap(
          (value) => repository
              .fetchPage(
                _paginatedList.value!.pageNumber + 1,
                _paginatedList.value!.pageSize,
              )
              .asResultStream(),
        )
        .setResultStateHandler(this)
        .mergeWithPaginatedList(_paginatedList)
        .bind(_paginatedList)
        .disposedBy(_compositeSubscription);
  }

  @override
  Stream<PaginatedList<Dummy>> _mapToPaginatedListState() => _paginatedList;

  //TODO: Make sure this is working
  @override
  Future<bool> get refreshDone async {
    await loadingState.lastWhere((loading) => loading == true);
    await loadingState.lastWhere((loading) => loading == false);

    return true;
  }

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((event) => event.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  void dispose() {
    _paginatedList.close();
    super.dispose();
  }
}

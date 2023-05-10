import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
part 'profile_list_bloc.rxb.g.dart';
part 'profile_list_bloc_extensions.dart';

/// A contract class containing all events of the ProfileBloC.
abstract class ProfileListBlocEvents {
  /// Load the next page of data. If reset is true, refresh the data and load
  /// the very first page
  void loadPage({bool reset = false});
}

/// A contract class containing all states of the ProfileListBloC.
abstract class ProfileListBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// The paginated list data
  Stream<PaginatedList<Profile>> get paginatedList;

  /// Returns when the data refreshing has completed
  @RxBlocIgnoreState()
  Future<void> get refreshDone;
}

/// Profile Bloc
@RxBloc()
class ProfileListBloc extends $ProfileListBloc {
  /// ProfileListBloc default constructor
  ProfileListBloc({required ProfileRepository repository}) {
    _$loadPageEvent
        // Start the data fetching immediately when the page loads
        .startWith(true)
        .fetchData(repository, _paginatedList)
        // Enable state handling by the current bloc
        .setResultStateHandler(this)
        // Merge the data in the _paginatedList
        .mergeWithPaginatedList(_paginatedList)
        .bind(_paginatedList)
        // Make sure we dispose the subscription
        .addTo(_compositeSubscription);
  }

  /// Internal paginated list stream
  final _paginatedList = BehaviorSubject<PaginatedList<Profile>>.seeded(
    PaginatedList<Profile>(
      list: [],
      pageSize: 50,
    ),
  );

  @override
  Future<void> get refreshDone async => _paginatedList.waitToLoad();

  @override
  Stream<PaginatedList<Profile>> _mapToPaginatedListState() => _paginatedList;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  /// Disposes of all streams to prevent memory leaks
  @override
  void dispose() {
    _paginatedList.close();
    super.dispose();
  }
}
import 'package:collection/collection.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../base/services/reminders_service.dart';
import '../services/reminder_list_service.dart';

part 'reminder_list_bloc.rxb.g.dart';
part 'reminder_list_bloc_extensions.dart';

/// A contract class containing all events of the ReminderBloC.
abstract class ReminderListBlocEvents {
  /// Load the next page of data. If reset is true, refresh the data and load
  /// the very first page
  void loadPage({bool reset = false});
}

/// A contract class containing all states of the ReminderListBloC.
abstract class ReminderListBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  /// The paginated list data
  Stream<PaginatedList<ReminderModel>> get paginatedList;

  /// Returns when the data refreshing has completed
  @RxBlocIgnoreState()
  Future<void> get refreshDone;
}

/// Reminder Bloc
@RxBloc()
class ReminderListBloc extends $ReminderListBloc {
  /// ReminderListBloc default constructor
  ReminderListBloc(
    ReminderListService reminderListService,
    RemindersService service,
    CoordinatorBlocType coordinatorBloc,
  ) {
    _$loadPageEvent
        // Start the data fetching immediately when the page loads
        .startWith(true)
        .fetchData(service, _paginatedList)
        // Enable state handling by the current bloc
        .setResultStateHandler(this)
        // Merge the data in the _paginatedList
        .mergeWithPaginatedList(_paginatedList)
        .bind(_paginatedList)
        // Make sure we dispose the subscription
        .addTo(_compositeSubscription);

    coordinatorBloc
        .mapReminderManageEventsWithLatestFrom(
          _paginatedList,
          operationCallback:
              (Identifiable reminder, List<ReminderModel> list) async =>
                  ManageOperation.merge,
        )
        .map((event) => event.list as PaginatedList<ReminderModel>)
        .map(
          (list) => list.copyWith(
            list: list.list.sorted(
              (a, b) => a.dueDate.compareTo(b.dueDate),
            ),
          ),
        )
        .bind(_paginatedList)
        .addTo(_compositeSubscription);
  }

  /// Internal paginated list stream
  final _paginatedList = BehaviorSubject<PaginatedList<ReminderModel>>.seeded(
    PaginatedList<ReminderModel>(
      list: [],
      pageSize: 10,
    ),
  );

  @override
  Future<void> get refreshDone async => _paginatedList.waitToLoad();

  @override
  Stream<PaginatedList<ReminderModel>> _mapToPaginatedListState() =>
      _paginatedList;

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((event) => event.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  /// Disposes of all streams to prevent memory leaks
  @override
  void dispose() {
    _paginatedList.close();
    super.dispose();
  }
}

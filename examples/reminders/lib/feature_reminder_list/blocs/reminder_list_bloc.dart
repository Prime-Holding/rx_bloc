import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'reminder_list_bloc.rxb.g.dart';
part 'reminder_list_bloc_extensions.dart';

/// A contract class containing all events of the ReminderListBloC.
abstract class ReminderListBlocEvents {
  /// TODO: Document the event
  void fetchData();
}

/// A contract class containing all states of the ReminderListBloC.
abstract class ReminderListBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  /// TODO: Document the state
  Stream<Result<String>> get data;
}

@RxBloc()
class ReminderListBloc extends $ReminderListBloc {
  @override
  Stream<Result<String>> _mapToDataState() => _$fetchDataEvent
      .startWith(null)
      .mapToData()
      .setResultStateHandler(this)
      .shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToErrorsState() => errorState.toMessage();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}

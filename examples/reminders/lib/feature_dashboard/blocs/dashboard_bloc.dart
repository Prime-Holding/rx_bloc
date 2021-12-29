import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'dashboard_bloc.rxb.g.dart';
part 'dashboard_bloc_extensions.dart';

/// A contract class containing all events of the DashboardBloC.
abstract class DashboardBlocEvents {
  /// TODO: Document the event
  void fetchData();
}

/// A contract class containing all states of the DashboardBloC.
abstract class DashboardBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  /// TODO: Document the state
  Stream<Result<String>> get data;
}

@RxBloc()
class DashboardBloc extends $DashboardBloc {
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

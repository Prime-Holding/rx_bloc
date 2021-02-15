import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'test_bloc.rxb.g.dart';

/// A contract class containing all events of the TestBloC.
abstract class TestBlocEvents {
  /// TODO: Declare your first event
  // void fetchData();
}

/// A contract class containing all states of the TestBloC.
abstract class TestBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;
}

@RxBloc()
class TestBloc extends $TestBloc {
  /// TODO: Implement error event-to-state logic
  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((error) => error.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}

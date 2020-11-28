import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

void main() async {
  print('----------RX_BLOC----------');

  /// Create a `CounterBloc` instance.
  final bloc = CounterBloc(ServerSimulator());

  /// Listen to the state
  bloc.states.count.listen((int number) {
    print('onChange -- the number is $number');
  });

  /// Listen to the error state
  bloc.states.errors.listen((String error) {
    print('onError -- $error');
  });

  /// Listen to the loading state
  bloc.states.isLoading.listen((bool isLoading) {
    print(isLoading ? 'Loading...' : 'Loaded ☑');
  });

  await Future.delayed(Duration(milliseconds: 500));

  /// Increment once
  bloc.events.increment();

  await Future.delayed(Duration(milliseconds: 500));

  /// Increment again.
  bloc.events.increment();
}

/// This bloc class usually resides in counter_bloc.dart
class CounterBloc extends $CounterBloc {
  CounterBloc(this._server);

  ServerSimulator _server;

  /// Map the count digit to presentable data
  @override
  Stream<int> _mapToCountState() =>
      // we map event to state reactively.
      _$incrementEvent
          // Show the initial counter value.
          .startWith(null)
          // On increment.
          .flatMap(
            (_) => _server
                .increment()
                // Converts the Future to a result so we can handle it.
                .asResultStream(),
          )
          // This automatically handles the error and loading state.
          .setResultStateHandler(this)
          // Provide success response only.
          .whereSuccess();

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((Exception error) => error.toString());

  /// Map event to s
  @override
  Stream<bool> _mapToIsLoadingState() => loadingState.skip(3);
}

/// BLoc class end

/// A contract class containing all events.
abstract class CounterBlocEvents {
  /// Increment the count
  void increment();
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {
  /// The count of the Counter
  ///
  /// It can be controlled by executing [CounterBlocEvents.increment] and
  /// [CounterBlocEvents.decrement]
  ///
  Stream<int> get count;

  /// Loading state
  Stream<bool> get isLoading;

  /// Error messages
  Stream<String> get errors;
}

/// ********************GENERATED CODE**************************************
/// NO NEED TO ANALYZE IT
/// This is a code that will be automatically generated for you by the rx_bloc_generator
/// This generated class usually resides in [file-name].rxb.g.dart.
/// Find more info at https://pub.dev/packages/rx_bloc_generator.

/// CounterBlocType class used for bloc event and state access from widgets
abstract class CounterBlocType extends RxBlocTypeBase {
  CounterBlocEvents get events;

  CounterBlocStates get states;
}

/// $CounterBloc class - extended by the CounterBloc bloc
abstract class $CounterBloc extends RxBlocBase
    implements CounterBlocEvents, CounterBlocStates, CounterBlocType {
  final _$incrementEvent = PublishSubject<void>();

  @override
  void increment() => _$incrementEvent.add(null);

  Stream<int> _countState;

  @override
  Stream<int> get count => _countState ??= _mapToCountState();

  Stream<int> _mapToCountState();

  Stream<bool> _isLoadingState;

  @override
  Stream<bool> get isLoading => _isLoadingState ??= _mapToIsLoadingState();

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _errorsState;

  @override
  Stream<String> get errors => _errorsState ??= _mapToErrorsState();

  Stream<String> _mapToErrorsState();

  @override
  CounterBlocEvents get events => this;

  @override
  CounterBlocStates get states => this;

  /// Dispose of all the opened streams when the bloc is closed.
  void dispose() {
    _$incrementEvent.close();
    super.dispose();
  }
}

/// ********************GENERATED CODE END**************************************

/// This will simulate a server with 100 milliseconds response time
class ServerSimulator {
  int _counter = 0;

  Future<int> increment() async {
    // Server response time.
    await Future.delayed(Duration(milliseconds: 100));
    // Simulate an error from the server when the counter reached 2.
    if (_counter == 2) {
      throw Exception('Maximum number is reached!');
    }

    return _counter++;
  }
}

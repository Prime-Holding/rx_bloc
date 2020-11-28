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
    print(isLoading ? 'Loading...' : 'Loaded ☑ \n');
  });

  /// Increment once
  await Future.delayed(Duration(milliseconds: 500));
  bloc.events.increment();

  /// Increment again.
  await Future.delayed(Duration(milliseconds: 500));
  bloc.events.increment();

  /// Increment again to cause exception
  await Future.delayed(Duration(milliseconds: 500));
  bloc.events.increment();

  /// Decrement
  await Future.delayed(Duration(milliseconds: 500));
  bloc.events.decrement();
}

/// This BloC and its event and state contracts usually
/// resides in counter_bloc.dart

/// A contract class containing all events.
abstract class CounterBlocEvents {
  /// Increment the count
  void increment();

  /// Decrement the count
  void decrement();
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

class CounterBloc extends $CounterBloc {
  CounterBloc(this._server);

  ServerSimulator _server;

  /// Map increment and decrement events to `count` state
  @override
  Stream<int> _mapToCountState() => Rx.merge<Result<int>>([
        // On increment.
        _$incrementEvent.flatMap((_) => _server.increment().asResultStream()),
        // On decrement.
        _$decrementEvent.flatMap((_) => _server.decrement().asResultStream()),
      ])
          // This automatically handles the error and loading state.
          .setResultStateHandler(this)
          // Provide success response only.
          .whereSuccess()
          //emit 0 as initial value
          .startWith(0);

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((Exception error) => error.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}

/// BLoc class end

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

    return ++_counter;
  }

  Future<int> decrement() async {
    // Server response time.
    await Future.delayed(Duration(milliseconds: 100));
    // Simulate an error from the server when the counter reached 2.
    if (_counter <= 0) {
      throw Exception('Minimum number is reached!');
    }

    return --_counter;
  }
}

/// NO NEED TO ANALYZE IT!
///
/// The code below will be automatically generated
/// for you by `rx_bloc_generator`.
///
/// This generated class usually resides in [file-name].rxb.g.dart.
/// Find more info at https://pub.dev/packages/rx_bloc_generator.

/// ********************GENERATED CODE**************************************
/// CounterBlocType class used for bloc event and state access from widgets
abstract class CounterBlocType extends RxBlocTypeBase {
  CounterBlocEvents get events;

  CounterBlocStates get states;
}

/// $CounterBloc class - extended by the CounterBloc bloc
abstract class $CounterBloc extends RxBlocBase
    implements CounterBlocEvents, CounterBlocStates, CounterBlocType {
  final _$decrementEvent = PublishSubject<void>();

  @override
  void decrement() => _$decrementEvent.add(null);

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

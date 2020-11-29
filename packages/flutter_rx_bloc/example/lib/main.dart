import 'package:counter/counter_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'counter_bloc.rxb.g.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RxBlocProvider<CounterBlocType>(
        create: (ctx) => CounterBloc(CounterRepository()),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Counter sample")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RxBlocListener<CounterBlocType, String>(
              state: (bloc) => bloc.states.errors,
              listener: (context, errorMessage) =>
                  ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  behavior: SnackBarBehavior.floating,
                ),
              ),
            ),
            RxBlocBuilder<CounterBlocType, int>(
              state: (bloc) => bloc.states.count,
              builder: (context, snapshot, bloc) => snapshot.hasData
                  ? Text(
                      snapshot.data.toString(),
                      style: Theme.of(context).textTheme.headline4,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _buildActionButtons(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildActionButtons() => RxBlocBuilder<CounterBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, loadingState, bloc) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (loadingState.isLoading)
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: CircularProgressIndicator(),
              ),
            FloatingActionButton(
              backgroundColor: loadingState.buttonColor,
              onPressed: loadingState.isLoading ? null : bloc.events.increment,
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              backgroundColor: loadingState.buttonColor,
              onPressed: loadingState.isLoading ? null : bloc.events.decrement,
              tooltip: 'Decrement',
              child: Icon(Icons.remove),
            ),
          ],
        ),
      );
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

@RxBloc()
class CounterBloc extends $CounterBloc {
  CounterBloc(this._repository);

  CounterRepository _repository;

  /// Map increment and decrement events to `count` state
  @override
  Stream<int> _mapToCountState() => Rx.merge<Result<int>>([
        // On increment.
        _$incrementEvent
            .flatMap((_) => _repository.increment().asResultStream()),
        // On decrement.
        _$decrementEvent
            .flatMap((_) => _repository.decrement().asResultStream()),
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

extension AsyncSnapshotLoadingState on AsyncSnapshot<bool> {
  bool get isLoading => hasData && data;
  Color get buttonColor => isLoading ? Colors.blueGrey : Colors.blue;
}

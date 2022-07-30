import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const CounterApp());
}

///region UI Layer

/// The app widget
class CounterApp extends StatelessWidget {
  const CounterApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter sample',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RxBlocProvider<CounterBlocType>(
        create: (ctx) => CounterBloc(CounterRepository()),
        child: const CounterPage(),
      ),
    );
  }
}

/// The page widget
class CounterPage extends StatelessWidget {
  /// Default constructor
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Counter sample')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildErrorListener(),
              _buildCount(),
            ],
          ),
        ),
        floatingActionButton: _buildActionButtons(),
      );

  Widget _buildCount() => RxBlocBuilder<CounterBlocType, int>(
        state: (bloc) => bloc.states.count,
        builder: (context, snapshot, bloc) => snapshot.hasData
            ? Text(
                snapshot.data.toString(),
                style: Theme.of(context).textTheme.headline4,
              )
            : Container(),
      );

  Widget _buildErrorListener() => RxBlocListener<CounterBlocType, String>(
        state: (bloc) => bloc.states.errors,
        listener: (context, errorMessage) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? 'Unknown error'),
            behavior: SnackBarBehavior.floating,
          ),
        ),
      );

  Widget _buildActionButtons() => RxLoadingBuilder<CounterBlocType>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, isLoading, tag, bloc) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ActionButton(
              tooltip: 'Increment',
              iconData: Icons.add,
              onPressed: bloc.events.increment,
              disabled: isLoading,
              loading: isLoading && tag == CounterBloc.tagIncrement,
            ),
            const SizedBox(width: 16),
            ActionButton(
              tooltip: 'Decrement',
              iconData: Icons.remove,
              onPressed: bloc.events.decrement,
              disabled: isLoading,
              loading: isLoading && tag == CounterBloc.tagDecrement,
            ),
          ],
        ),
      );
}

/// Increment/Decrement button
class ActionButton extends StatelessWidget {
  /// Default constructor
  const ActionButton({
    required this.iconData,
    required this.onPressed,
    this.disabled = false,
    this.tooltip = '',
    this.loading = false,
    Key? key,
  }) : super(key: key);

  /// The button disable state, which removes the [onPress] and sets a color
  final bool disabled;

  /// Loading flag that shows a loading indicator
  final bool loading;

  /// Text that describes the action that will occur when the button is pressed.
  final String tooltip;

  /// The icon to display. The available icons are described in [Icons].
  final IconData iconData;

  /// The callback that is called when the button is tapped or
  /// otherwise activated.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: CircularProgressIndicator(),
      );
    }

    return FloatingActionButton(
      backgroundColor: disabled ? Colors.blueGrey : Colors.blue,
      onPressed: !disabled ? onPressed : null,
      tooltip: tooltip,
      child: Icon(iconData),
    );
  }
}

/// Utils
extension AsyncSnapshotLoadingState on AsyncSnapshot<bool> {
  /// The loading state extracted from the snapshot
  bool get isLoading => hasData && data!;

  /// The color based on the isLoading state
  Color get buttonColor => isLoading ? Colors.blueGrey : Colors.blue;
}

///endregion

///region Business Layer

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
  Stream<LoadingWithTag> get isLoading;

  /// Error messages
  Stream<String> get errors;
}

/// A BloC responsible for count calculations
@RxBloc()
class CounterBloc extends $CounterBloc {
  /// Default constructor
  CounterBloc(this._repository);

  final CounterRepository _repository;

  /// Increment action
  static const tagIncrement = 'Increment';

  /// Decrement action
  static const tagDecrement = 'Decrement';

  /// Map increment and decrement events to `count` state
  @override
  Stream<int> _mapToCountState() => Rx.merge<Result<int>>([
        // On increment.
        _$incrementEvent.switchMap(
            (_) => _repository.increment().asResultStream(tag: tagIncrement)),
        // On decrement.
        _$decrementEvent.switchMap(
            (_) => _repository.decrement().asResultStream(tag: tagDecrement)),
      ])
          // This automatically handles the error and loading state.
          .setResultStateHandler(this)
          // Provide success response only.
          .whereSuccess()
          //emit 0 as initial value
          .startWith(0);

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((error) => error.toString());

  @override
  Stream<LoadingWithTag> _mapToIsLoadingState() => loadingWithTagState;
}

///endregion

///region Data Layer

/// This will simulate a server with 100 milliseconds response time
class CounterRepository {
  int _counter = 0;

  /// Increment the stored counter by one
  Future<int> increment() async {
    // Server response time.
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate an error from the server when the counter reached 2.
    if (_counter == 2) {
      throw Exception('Maximum number is reached!');
    }

    return ++_counter;
  }

  /// Decrement the stored counter by one
  Future<int> decrement() async {
    // Server response time.
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate an error from the server when the counter reached 2.
    if (_counter <= 0) {
      throw Exception('Minimum number is reached!');
    }

    return --_counter;
  }
}

///endregion

///region auto-generated code

/// The code below will be automatically generated
/// for you by `rx_bloc_generator`.
///
/// This generated class usually resides in [file-name].rxb.g.dart.
/// Find more info at https://pub.dev/packages/rx_bloc_generator.

/// ********************GENERATED CODE**************************************
/// CounterBlocType class used for bloc event and state access from widgets
abstract class CounterBlocType extends RxBlocTypeBase {
  // ignore: public_member_api_docs
  CounterBlocEvents get events;

  // ignore: public_member_api_docs
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

  late final Stream<int> _countState = _mapToCountState();

  @override
  Stream<int> get count => _countState;

  Stream<int> _mapToCountState();

  late final Stream<LoadingWithTag> _isLoadingState = _mapToIsLoadingState();

  @override
  Stream<LoadingWithTag> get isLoading => _isLoadingState;

  Stream<LoadingWithTag> _mapToIsLoadingState();

  late final Stream<String> _errorsState = _mapToErrorsState();

  @override
  Stream<String> get errors => _errorsState;

  Stream<String> _mapToErrorsState();

  @override
  CounterBlocEvents get events => this;

  @override
  CounterBlocStates get states => this;

  /// Dispose of all the opened streams when the bloc is closed.
  @override
  void dispose() {
    _$incrementEvent.close();
    super.dispose();
  }
}

/// ********************GENERATED CODE END**************************************

///endregion

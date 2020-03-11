import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'counter_bloc.g.dart';

/// A class containing all incoming events to the BloC
abstract class CounterBlocEvents {
  /// Increment the count
  void increment();

  /// Decrement the count
  void decrement();
}

/// A class containing all states (outputs) of the bloc.
abstract class CounterBlocStates {
  /// The count of the Counter
  ///
  /// It can be controlled by executing [CounterBlocEvents.increment] and
  /// [CounterBlocEvents.decrement]
  ///
  Stream<String> get count;

  /// The state of the increment action control
  Stream<bool> get incrementEnabled;

  /// The state of the decrement action control
  Stream<bool> get decrementEnabled;

  /// The info message caused by changing action controls' state
  Stream<String> get infoMessage;
}

@RxBloc()
class CounterBloc extends $CounterBloc {
  /// The internal storage of the count
  final _count = BehaviorSubject.seeded(0);

  /// Acts as a container for multiple subscriptions that can be canceled at once
  final _compositeSubscription = CompositeSubscription();

  CounterBloc() {
    MergeStream([
      _$incrementEvent.map((_) => _count.value + 1),
      _$decrementEvent.map((_) => _count.value - 1)
    ]).bind(_count).disposedBy(_compositeSubscription);
  }

  /// Map the count digit to presentable data
  @override
  Stream<String> _mapToCountState() => _count.map((count) => count.toString());

  /// Map the count digit to a decrement enabled state.
  @override
  Stream<bool> _mapToDecrementEnabledState() =>
      _count.map((count) => count > 0);

  /// Map the count digit to a increment enabled state.
  @override
  Stream<bool> _mapToIncrementEnabledState() =>
      _count.map((count) => count < 5);

  /// Map the increment and decrement enabled state to a informational message.
  @override
  Stream<String> _mapToInfoMessageState() => MergeStream([
        incrementEnabled.mapToMaximumMessage(),
        decrementEnabled.mapToMinimumMessage(),
      ]).skip(1).throttleTime(Duration(seconds: 1));

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }
}

extension _InfoMessage on Stream<bool> {
  /// Map disabled state to a informational message
  Stream<String> mapToMaximumMessage() => where((enabled) => !enabled)
      .map((_) => "You have reached the maximum increment count");

  /// Map disabled state to a informational message
  Stream<String> mapToMinimumMessage() => where((enabled) => !enabled)
      .map((_) => "You have reached the minimum decrement count");
}

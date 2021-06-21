import 'package:rx_bloc/rx_bloc.dart';

/// A contract class containing all events.
abstract class CounterBlocEvents {}

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

abstract class CounterBlocType extends RxBlocTypeBase {
  // ignore: public_member_api_docs
  CounterBlocEvents get events;

  // ignore: public_member_api_docs
  CounterBlocStates get states;
}

class CounterBloc
    implements CounterBlocEvents, CounterBlocStates, CounterBlocType {
  CounterBloc({
    this.countEvents = const [],
    this.errorEvents = const [],
    this.isLoadingEvents = const [],
  });

  final List<int> countEvents;
  final List<String> errorEvents;
  final List<bool> isLoadingEvents;

  @override
  Stream<int> get count => Stream.fromIterable(countEvents);

  @override
  Stream<String> get errors => Stream.fromIterable(errorEvents);

  @override
  Stream<bool> get isLoading => Stream.fromIterable(isLoadingEvents);

  @override
  void dispose() {}

  @override
  CounterBlocEvents get events => this;

  @override
  CounterBlocStates get states => this;
}

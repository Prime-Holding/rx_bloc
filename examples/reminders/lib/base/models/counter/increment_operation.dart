import 'package:rx_bloc_list/models.dart';

enum IncrementOperation {
  /// The operation, which increments the incomplete counter and decrements
  /// the complete counter
  incrementIncompleteDecrementComplete,

  /// The operation, which decrements the incomplete counter and increments
  /// the complete counter
  decrementIncompleteIncrementComplete,
}

/// This operation should be in the reminders list
enum CounterOperation {
  /// The operation, which just increments the incomplete counter
  create,

  /// The operation, which decrements the incomplete or complete counter
  delete,

  /// The operation, which decrements incomplete and increments complete or
  /// increments incomplete and decrements complete or
  /// does not change counter
  update,
}

class ManagedListCounterOperation<E extends Identifiable>{
  ManagedListCounterOperation({
    required this.managedList,
    required this.counterOperation,
  });

  final ManagedList<E> managedList;
  final CounterOperation counterOperation;
}
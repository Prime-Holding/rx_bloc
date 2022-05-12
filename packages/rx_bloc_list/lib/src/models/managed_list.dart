import 'package:collection/collection.dart';

import 'identifiable.dart';

/// The managed operation of a [Identifiable] object.
/// - [merge] - Added or Updated
/// - [remove] - Removed
/// - [ignore] - Ignored
enum ManageOperation {
  /// Merge the [Identifiable] object to the list
  merge,

  /// Remove the [Identifiable] object from the list
  remove,

  /// Neither merge or remove the [Identifiable] object from the list
  ignore,
}

enum CounterOperation {
  /// increment incomplete
  create,

  /// decrement either incomplete or complete
  delete,

  /// decrement incomplete and increment complete or
  /// increment incomplete and decrement complete or
  /// do nothing
  update,
}

/// A class containing the list along with the managed [Identifiable] object.
class ManagedList<T extends Identifiable> {
  ManagedList(
    this.list, {
    required this.identifiable,
    required this.operation,
    required this.counterOperation,
  });

  /// The managed operation of the [identifiable] object
  final ManageOperation operation;

  /// The counter operation of the [identifiable] object
  final CounterOperation counterOperation;

  /// The managed object
  final T identifiable;

  /// The managed list
  final List<T> list;

  ManagedList copyWith({
    ManageOperation? operation,
    CounterOperation? counterOperation,
    T? identifiable,
    List<T>? list,
  }) =>
      ManagedList(
        list ?? this.list,
        operation: operation ?? this.operation,
        counterOperation: counterOperation ?? this.counterOperation,
        identifiable: identifiable ?? this.identifiable,
      );

  @override
  bool operator ==(other) {
    if (other is ManagedList<T>) {
      return const ListEquality().equals(other.list, list) &&
          operation == other.operation &&
          identifiable.id == other.identifiable.id;
    }

    return false;
  }

  @override
  int get hashCode =>
      list.hashCode ^ operation.hashCode ^ identifiable.hashCode;
}

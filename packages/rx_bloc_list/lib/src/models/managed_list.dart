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
  /// The operation, which just increments the incomplete counter
  create,

  /// The operation, which decrements the incomplete or complete counter
  delete,

  /// The operation, which decrements incomplete and increments complete or
  /// increments incomplete and decrements complete or
  /// does not change counter
  update,
}

/// A class containing the list along with the managed [Identifiable] object.
class ManagedList<T extends Identifiable> {
  ManagedList(
    this.list, {
    required this.identifiable,
    required this.operation,
    required this.counterOperation,
    this.identifiableInList,
  });

  /// The managed operation of the [identifiable] object
  final ManageOperation operation;

  /// The counter operation of the [identifiable] object
  final CounterOperation counterOperation;

  /// The managed object
  final T identifiable;

  final T? identifiableInList;

  /// The managed list
  final List<T> list;

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

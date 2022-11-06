import 'package:collection/collection.dart';

import '../../models.dart';

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

/// A class containing the list along with the managed [Identifiable] object.
class ManagedList<T extends Identifiable> {
  ManagedList(
    this.list, {
    required this.identifiable,
    required this.operation,
  });

  /// The managed operation of the [identifiable] object
  final ManageOperation operation;

  /// The managed object
  final T identifiable;

  /// The managed list
  final List<T> list;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is ManagedList<T> &&
          const ListEquality().equals(other.list, list) &&
          operation == other.operation &&
          identifiable == other.identifiable;

  @override
  int get hashCode =>
      list.hashCode ^ operation.hashCode ^ identifiable.hashCode;

  @override
  String toString() =>
      '{list: $list, identifiable: $identifiable, operation: $operation}';
}

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

/// A class containing the list along with the managed [Identifiable] object:
/// [updatedIdentifiable], which is part of [identifiablePair].
class ManagedList<T extends Identifiable> {
  ManagedList(
    this.list, {
    required this.identifiablePair,
    required this.operation,
  });

  /// The managed operation of the [updatedIdentifiable] object
  final ManageOperation operation;

  /// The object containing the managed object [updatedIdentifiable]
  final IdentifiablePair<T> identifiablePair;

  /// The managed list
  final List<T> list;

  @override
  bool operator ==(other) {
    if (other is ManagedList<T>) {
      return const ListEquality().equals(other.list, list) &&
          operation == other.operation &&
          identifiablePair == other.identifiablePair;
    }
    return false;
  }

  @override
  int get hashCode =>
      list.hashCode ^ operation.hashCode ^ identifiablePair.hashCode;
}

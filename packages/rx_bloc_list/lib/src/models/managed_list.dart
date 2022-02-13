import 'identifiable.dart';

enum ManageOperation {
  /// Merge the given object to the list
  merge,

  /// Remove the given object from the list
  remove,

  /// Neither merge or remove the given object from the list
  ignore,
}

class ManagedList<T extends Identifiable> {
  ManagedList(
    this.list, {
    required this.operation,
    required this.identifiable,
  });

  final ManageOperation operation;
  final T identifiable;
  final List<T> list;
}

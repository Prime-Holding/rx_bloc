import '../../models.dart';

class IdentifiablePair<E extends Identifiable> {
  IdentifiablePair({
    required this.updatedIdentifiable,
    this.oldIdentifiable,
  });

  /// The managed object
  final E updatedIdentifiable;

  /// The object, which represents an element from the list with the same
  /// id as the [updatedIdentifiable].
  final E? oldIdentifiable;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentifiablePair &&
          runtimeType == other.runtimeType &&
          updatedIdentifiable.id == other.updatedIdentifiable.id &&
          oldIdentifiable?.id == other.oldIdentifiable?.id;

  @override
  int get hashCode => updatedIdentifiable.hashCode ^ oldIdentifiable.hashCode;
}

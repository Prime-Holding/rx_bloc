import '../../models.dart';

/// A class, which combines two elements in an identifiable pair.
///
/// A stream of type [IdentifiablePair] could be extended with the method
/// [withLatestFromIdentifiablePairList]
class IdentifiablePair<E extends Identifiable> {
  IdentifiablePair({
    required this.updatedIdentifiable,
    this.oldIdentifiable,
  });

  /// The managed object
  final E updatedIdentifiable;

  /// The object, which represents an element from the list with the same
  /// id as the [updatedIdentifiable].
  /// This object is null when an object with the [updatedIdentifiable]'s
  /// object id has not been present in the list.
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

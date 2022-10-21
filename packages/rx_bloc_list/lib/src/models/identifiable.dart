abstract class Identifiable {
  Object get id;

  bool isEqualToIdentifiable(Identifiable other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType && id == other.id;
}

import '../../models.dart';

class IdentifiablePair<E extends Identifiable> {
  IdentifiablePair({required this.old, required this.updated});

  E old;
  E updated;
}

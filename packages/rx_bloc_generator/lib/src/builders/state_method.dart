part of '../../rx_bloc_generator.dart';

// ignore_for_file: deprecated_member_use
// TODO: Remove the ignore once a new version of `source_gen` is released

/// A mapper that converts a [MethodElement] into an event [Method]
class _StateMethod implements _BuilderContract {
  const _StateMethod(this.field);

  final FieldElement field;

  @override
  Method build() => Method(
        (b) => b
          ..docs.addAll(['']) // A new line
          ..returns = refer(
            field.type.getDisplayString(withNullability: true),
          )
          ..name = field.stateMethodName,
      );
}

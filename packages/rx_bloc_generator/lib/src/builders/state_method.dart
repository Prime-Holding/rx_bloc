part of '../../rx_bloc_generator.dart';

/// A mapper that converts a [MethodElement] into an event [Method]
class _StateMethod implements _BuilderContract {
  const _StateMethod(this.field);

  final FieldElement field;

  @override
  Method build() => Method(
        (b) => b
          ..docs.addAll(['']) // A new line
          ..returns = refer(
            field.type.getDisplayString(),
          )
          ..name = field.stateMethodName,
      );
}

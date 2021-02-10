part of rx_bloc_generator;

/// A mapper that converts a [MethodElement] into an event [Method]
class _StateMethod implements _BuilderContract<Method> {
  const _StateMethod(this.field);

  final FieldElement field;

  @override
  Method build() => Method(
        (b) => b
          // TODO(Diev): Add region comments
          ..returns = refer(
            field.type.getDisplayString(withNullability: false),
          )
          ..name = field.stateMethodName,
      );
}

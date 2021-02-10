part of rx_bloc_generator;

/// A mapper that converts a [MethodElement] into an event [Field]
class _EventField implements _BuilderContract<Field> {
  const _EventField(this.method);

  final MethodElement method;

  @override
  Field build() => Field(
        (b) => b
          // TODO(Diev): Add region comments
          ..modifier = FieldModifier.final$
          ..assignment = refer(method.eventStreamType)
              .newInstance(
                method.seedPositionalArguments,
                {},
                method.streamTypeArguments,
              )
              .code
          ..name = method.eventFieldName,
      );
}

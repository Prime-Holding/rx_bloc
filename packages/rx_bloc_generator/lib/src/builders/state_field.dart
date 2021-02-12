part of rx_bloc_generator;

/// A mapper that converts a [FieldElement] into an event [Field]
class _StateField implements _BuilderContract<Field> {
  const _StateField(this.field);

  final FieldElement field;

  @override
  Field build() => Field(
        (b) => b
          // TODO(Diev): Add region comments
          ..type = refer(
            field.type.getDisplayString(withNullability: false),
          )
          ..name = field.stateFieldName,
      );
}

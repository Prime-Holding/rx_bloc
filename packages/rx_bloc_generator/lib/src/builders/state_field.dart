part of rx_bloc_generator;

/// A mapper that converts a [FieldElement] into an event [Field]
class StateField implements _BuilderContract<Field> {
  const StateField(this.field);

  final FieldElement field;

  @override
  Field build() {
    return Field(
      (b) => b
        // TODO(Diev): Add region comments
        ..type = refer(
          field.type.getDisplayString(withNullability: false),
        )
        ..name = field.stateFieldName,
    );
  }
}

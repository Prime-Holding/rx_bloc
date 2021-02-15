part of rx_bloc_generator;

/// A mapper that converts a [FieldElement] into an event [Field]
class _StateField implements _BuilderContract {
  const _StateField(this.field);

  final FieldElement field;

  @override
  Field build() => Field(
        (b) => b
          ..docs.add('/// The state of [${field.name}] implemented in [${field.stateMethodName}]')
          ..type = refer(
            field.type.getDisplayString(withNullability: false),
          )
          ..name = field.stateFieldName,
      );
}

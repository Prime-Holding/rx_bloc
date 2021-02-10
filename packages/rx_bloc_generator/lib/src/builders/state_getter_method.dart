part of rx_bloc_generator;

/// A mapper that converts a [MethodElement] into an event [Method]
class _StateGetterMethod implements _BuilderContract<Method> {
  const _StateGetterMethod(this.field);

  final FieldElement field;

  @override
  Method build() => Method(
        (b) => b
          // TODO(Diev): Add region comments
          ..type = MethodType.getter
          ..annotations.add(refer('override'))
          ..returns = refer(field.type.getDisplayString(withNullability: false))
          ..name = field.name
          ..lambda = true
          ..body = refer(field.stateFieldName)
              .assignNullAware(
                refer(field.stateMethodName).newInstance([]),
              )
              .code,
      );
}

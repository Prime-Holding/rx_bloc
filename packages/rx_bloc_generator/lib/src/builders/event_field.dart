part of rx_bloc_generator;

/// A mapper that converts a [MethodElement] into an event [Field]
class _EventField implements _BuilderContract {
  const _EventField(this.method) : assert(method != null);

  final MethodElement method;

  @override
  Field build() => Field(
        (b) => b
          ..docs.addAll(<String>[
            if (method.name.length <= 26)
              '/// Тhe [Subject] where events sink to by calling [${method.name}]',
            if (method.name.length > 26) ...<String>[
              '/// Тhe [Subject] where events sink to by calling ',
              '/// [${method.name}]'
            ],
          ])
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

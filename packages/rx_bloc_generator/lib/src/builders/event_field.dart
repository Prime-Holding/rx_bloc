part of '../../rx_bloc_generator.dart';

/// A mapper that converts a [MethodElement2] into an event [Field]
class _EventField implements _BuilderContract {
  const _EventField(this.method);

  final MethodElement2 method;

  @override
  Field build() => Field(
        (b) => b
          ..docs.addAll(<String>[
            if ((method.name3?.length ?? 0) <= 26)
              '/// Тhe [Subject] where events sink to by calling [${method.name3}]',
            if ((method.name3?.length ?? 0) > 26) ...<String>[
              '/// Тhe [Subject] where events sink to by calling ',
              '/// [${method.name3}]'
            ],
          ])
          ..modifier = FieldModifier.final$
          ..assignment = method.hasSeedAnnotation
              ? refer(method.eventStreamType)
                  .newInstanceNamed(
                    'seeded',
                    method.seedPositionalArguments,
                  )
                  .code
              : refer(method.eventStreamType)
                  .newInstance([], {}, method.streamTypeArguments).code
          ..name = method.eventFieldName,
      );
}

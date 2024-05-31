part of '../../rx_bloc_generator.dart';

/// A mapper that converts a [FieldElement] into an event [Field]
class _StateField implements _BuilderContract {
  const _StateField(this.field);

  final FieldElement field;

  @override
  Field build() => Field(
        (b) => b
          ..docs.addAll(<String>[
            if (field.name.length <= 15)
              '/// The state of [${field.name}] implemented in [${field.stateMethodName}]',
            if (field.name.length > 15) ...<String>[
              '/// The state of [${field.name}] implemented in ',
              '/// [${field.stateMethodName}]'
            ]
          ])
          ..type = refer(
            // ignore: deprecated_member_use
            'late final ${field.type.getDisplayString(withNullability: true)}',
          )
          ..assignment = refer(field.stateMethodName).newInstance([]).code
          ..name = field.stateFieldName,
      );
}

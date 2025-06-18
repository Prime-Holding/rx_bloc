part of '../../rx_bloc_generator.dart';

// ignore_for_file: deprecated_member_use
// TODO: Remove the ignore once a new version of `source_gen` is released

/// A mapper that converts a [MethodElement] into an event [Method]
class _StateGetterMethod implements _BuilderContract {
  const _StateGetterMethod(this.field);

  final FieldElement field;

  @override
  Method build() => Method(
        (b) => b
          ..docs.addAll(['']) // A new line
          ..type = MethodType.getter
          ..annotations.add(refer('override'))
          ..returns = refer(field.type.getDisplayString(withNullability: true))
          ..name = field.name
          ..lambda = true
          ..body = refer(field.stateFieldName).code,
      );
}

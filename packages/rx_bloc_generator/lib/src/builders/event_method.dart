part of '../../rx_bloc_generator.dart';

/// A mapper that converts a [MethodElement] into an event [Method]
class _EventMethod implements _BuilderContract {
  const _EventMethod(this.method);

  final MethodElement method;

  @override
  Method build() => Method.returnsVoid(
        (b) => b
          ..docs.addAll(['']) // A new line
          ..annotations.add(
            refer('override'),
          )
          ..name = method.name
          ..requiredParameters.addAll(method.parameters.whereRequired().clone())
          ..optionalParameters.addAll(method.parameters.whereOptional().clone())
          ..lambda = true
          ..body = method.buildBody(),
      );
}

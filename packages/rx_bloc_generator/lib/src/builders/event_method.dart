part of rx_bloc_generator;

/// A mapper that converts a [MethodElement] into an event [Method]
class _EventMethod implements _BuilderContract {
  const _EventMethod(this.method) : assert(method != null);

  final MethodElement method;

  @override
  Method build() => Method.returnsVoid(
        (b) => b
          ..docs.addAll(['']) // A new line
          ..annotations.add(
            refer('override'),
          )
          ..name = method.name
          ..requiredParameters.addAll(
            method.buildRequiredParameters(),
          )
          ..optionalParameters.addAll(
            method.buildOptionalParameters(),
          )
          ..lambda = true
          ..body = method.buildBody(),
      );
}

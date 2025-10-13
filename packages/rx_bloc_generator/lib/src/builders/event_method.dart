part of '../../rx_bloc_generator.dart';

/// A mapper that converts a [MethodElement2] into an event [Method]
class _EventMethod implements _BuilderContract {
  const _EventMethod(this.method);

  final MethodElement2 method;

  @override
  Method build() => Method.returnsVoid(
        (b) => b
          ..docs.addAll(['']) // A new line
          ..annotations.add(
            refer('override'),
          )
          ..name = method.name3
          ..requiredParameters
              .addAll(method.formalParameters.whereRequired().clone())
          ..optionalParameters
              .addAll(method.formalParameters.whereOptional().clone())
          ..lambda = true
          ..body = method.buildBody(),
      );
}

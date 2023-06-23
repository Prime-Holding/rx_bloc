part of rx_bloc_generator;

// ignore: unused_element
class _EventArgsTypeDef implements _BuilderContract {
  _EventArgsTypeDef(this.method);

  final MethodElement method;

  @override
  Spec build() => TypeDef(
        (b) => b
          ..name = method.recordTypeDefName
          ..definition = refer(method.recordType),
      );
}

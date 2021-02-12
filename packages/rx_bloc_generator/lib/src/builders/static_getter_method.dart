part of rx_bloc_generator;

// Generates the 'events' and 'states' getter methods
class _StaticStateGetterMethod implements _BuilderContract {
  const _StaticStateGetterMethod(this.returnClassName, this.isEvent);

  final String returnClassName;

  final bool isEvent;

  @override
  Method build() => Method(
        (b) => b
          ..type = MethodType.getter
          ..annotations.add(refer('override'))
          ..returns = refer(returnClassName)
          ..name = isEvent ? 'events' : 'states'
          ..lambda = true
          ..body = const Code('this'),
      );
}

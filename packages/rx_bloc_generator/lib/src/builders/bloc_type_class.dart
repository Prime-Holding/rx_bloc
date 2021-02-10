part of rx_bloc_generator;

class _BlocTypeClass implements _RxBlocBuilder {
  _BlocTypeClass(
    this.className,
    this.eventClassName,
    this.stateClassName,
  );

  String className;

  String eventClassName;

  String stateClassName;

  /// Generates the type class for the blocClass
  ///
  ///  Example:
  ///  abstract class [RxBlocName]BlocType extends RxBlocTypeBase {
  ///    [RxBlocName]BlocEvents get events;
  ///    [RxBlocName]BlocStates get states;
  ///  }
  ///
  @override
  String build() => Class(
        (b) => b
          ..docs.addAll(<String>[
            '/// ${className} class used for blocClass event and '
                'state access from widgets',
            '/// {@nodoc}',
          ])
          ..abstract = true
          ..name = className
          ..extend = refer((RxBlocTypeBase).toString())
          ..methods.addAll(<Method>[
            Method(
              (b) => b
                ..name = 'events'
                ..returns = refer(eventClassName)
                ..type = MethodType.getter,
            ),
            Method(
              (b) => b
                ..name = 'states'
                ..returns = refer(stateClassName)
                ..type = MethodType.getter,
            ),
          ]),
      ).toDartCodeString();
}

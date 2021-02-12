part of rx_bloc_generator;

/// Generates the type class for the blocClass
///
///  Example:
///  abstract class {RxBlocName}BlocType extends RxBlocTypeBase {
///    {RxBlocName}BlocEvents get events;
///    {RxBlocName}BlocStates get states;
///  }
///
class _BlocTypeClass implements _BuilderContract {
  const _BlocTypeClass(
    this.className,
    this.eventClassName,
    this.stateClassName,
  );

  final String className;

  final String eventClassName;

  final String stateClassName;

  @override
  Class build() => Class(
        (b) => b
          ..docs.addAll(<String>[
            '/// $className class used for blocClass event and ' +
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
      );
}

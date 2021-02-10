part of rx_bloc_generator;

/// Generates the contents of the blocClass
///
/// Example:
/// abstract class $[RxBlocName]Bloc extends RxBlocBase
///    implements [RxBlocName]BlocEvents, [RxBlocName]BlocStates, [RxBlocName]BlocType {
///
///    /// Events
///    ...
///    /// States
///    ...
///    /// Type - events, states getters
///    ...
///    /// Dispose of all the opened streams
///    ...
/// }
///
class _BlocClass implements _BuilderContract<String> {
  const _BlocClass(
    this.className,
    this.blocTypeClassName,
    this.eventClassName,
    this.stateClassName,
    this.eventsMethods,
    this.statesFields,
  );

  final String className;

  final String blocTypeClassName;

  final String eventClassName;

  final String stateClassName;

  final List<MethodElement> eventsMethods;

  final List<FieldElement> statesFields;

  @override
  String build() => Class((b) => b
    ..docs.addAll(<String>[
      '/// ${className} class - extended by the CounterBloc bloc',
      '/// {@nodoc}',
    ])
    ..abstract = true
    ..name = className
    ..extend = refer((RxBlocBase).toString())
    ..implements.addAll(<Reference>[
      refer(eventClassName),
      refer(stateClassName),
      refer(blocTypeClassName),
    ])
    ..fields.addAll(<Field>[
      // final _$[eventName]Event = PublishSubject<void>();
      ...eventsMethods
          .map((MethodElement method) => _EventField(method).build())
          .toList(),
      // Stream<int> _[stateName]State;
      ...statesFields
          .map((FieldElement field) => _StateField(field).build())
          .toList(),
    ])
    ..methods.addAll(
      <Method>[
        // void [eventName]() => _$[eventName]Event.add(null);
        ...eventsMethods
            .map((MethodElement method) => _EventMethod(method).build())
            .toList(),
        // Stream<int> get [stateName] => _[stateName]State ??= _mapTo[StateName]State();
        ...statesFields
            .map((FieldElement field) => _StateGetterMethod(field).build())
            .toList(),
        // Stream<int> _mapTo[StateName]State();
        ...statesFields
            .map((FieldElement field) => _StateMethod(field).build())
            .toList(),
        // [BlocName]BlocEvents get events => this;
        _StaticStateGetterMethod(eventClassName, true).build(),
        // [BlocName]BlocStates get states => this;
        _StaticStateGetterMethod(stateClassName, false).build(),
        // void dispose() {
        //   .._$[eventMethod1]Event.close();
        //   .._$[eventMethod2]Event.close();
        //   ...
        //   ..super.dispose();
        // }
        _DisposeMethod(eventsMethods).build(),
      ],
    )).toDartCodeString();
}

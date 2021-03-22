/// BloC class that the generator will be looking for.
class RxBloc {
  /// By convention the `Events` class should be composed of ${blocName}Events.
  /// For instance of the BloC class name is `CounterBloc` the events abstract
  /// class should be named `abstract class CounterEvents`.
  /// In case you want to name it differently just provide
  /// the expected name in [eventsClassName].
  ///
  /// By convention the `States` class should be composed of ${blocName}States.
  /// For instance of the BloC class name is `CounterBloc` the events abstract
  /// class should be named `CounterStates`. In case you want to name it
  /// differently just provide the expected name in [statesClassName].
  const RxBloc({
    this.eventsClassName = 'Events',
    this.statesClassName = 'States',
  });

  /// Events class that the generator will be looking for.
  ///
  /// In case you need to name the BloC's event class with a name, which does
  /// not stick to the convention you can override it from here
  final String eventsClassName;

  /// States class that the generator will be looking for.
  ///
  /// In case you need to name the BloC's states class with a name, which does
  /// not stick to the convention you can override it from here
  final String statesClassName;
}

/// There might be some situations where you would need to define custom state,
/// where all generated boilerplate it would be redundant.
/// For that case just annotate the property of the states class
/// with @RxBlocIgnoreState() and the generator won't generate any boilerplate
/// code for it.
/// A good example of this is errors or loading states as shown
/// [here](https://github.com/Prime-Holding/RxBloc#usage).
class RxBlocIgnoreState {
  /// das das
  const RxBlocIgnoreState();
}

/// When working with events, most of the time, they are used to publish changes
/// to the bloc that do not require any initial state.
/// However, there may be some times when you are required to set the state
/// to a custom value or to explicitly annotate the event.
/// All this can be done with the @RxBlocEvent() annotation.
///
/// For more information look
/// [here](https://github.com/Prime-Holding/RxBlocGenerator#rxblocevent)
class RxBlocEvent {
  /// @RxBlocEvent annotation has two parameters: the type of the event and
  /// the seed value. The type specifies what kind of event will be generated
  /// and it can either be a publish event (the default one)
  /// or a behaviour event. The seed value, on the other hand,
  /// is a value that is valid if used with a behaviour event and represents
  /// the initial seed. If the annotation is omitted, the event is treated as
  /// a publish event.
  const RxBlocEvent({
    this.type = RxBlocEventType.publish,
    this.seed,
  });

  /// Type of the event, that can be either [RxBlocEventType.behaviour] or
  /// [RxBlocEventType.publish]
  final RxBlocEventType type;

  /// The initial value of the event
  final dynamic? seed;
}

/// Subject type of the event. It could be either [RxBlocEventType.behaviour]
/// or [RxBlocEventType.publish]
///
/// In case the type of choice is [RxBlocEventType.behaviour] there could be
/// set a initial (seed) value.
enum RxBlocEventType {
  /// The type of the subject that generator will generate.
  behaviour,

  /// The type of the subject that generator will generate.
  publish,
}

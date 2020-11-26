class RxBloc {
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

  const RxBloc({
    this.eventsClassName = "Events",
    this.statesClassName = "States",
  });
}

/// There might be some situations where you would need to define custom state,
/// where all generated boilerplate it would be redundant.
/// For that case just annotate the property of the states class
/// with @RxBlocIgnoreState() and the generator won't generate any boilerplate
/// code for it.
/// A good example of this is errors or loading states as shown
/// [here](https://github.com/Prime-Holding/RxBloc#usage).
class RxBlocIgnoreState {
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
  /// Type of the event, that can be either `behaviour` or `publish`
  final RxBlocEventType type;

  /// Initial value of the event
  final dynamic seed;

  const RxBlocEvent({
    this.type = RxBlocEventType.publish,
    this.seed,
  });
}

enum RxBlocEventType { behaviour, publish }

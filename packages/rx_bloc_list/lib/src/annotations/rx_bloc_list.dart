/// BloC class that the generator will be looking for.
class RxBlocList {
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
  const RxBlocList({
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

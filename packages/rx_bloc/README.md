![CI](https://github.com/Prime-Holding/rx_bloc/workflows/CI/badge.svg) ![style](https://img.shields.io/badge/style-effective_dart-40c4ff.svg) ![license](https://img.shields.io/badge/license-MIT-purple.svg)

# What is rx_bloc
**rx_bloc** is a state management solution that helps you building robust, scalable, and maintainable Flutter apps.

Along with the [rx_bloc](https://pub.dev/packages/rx_bloc) the following set of packages will help you during the product development.
1. [flutter_rx_bloc](https://pub.dev/packages/flutter_rx_bloc) that exposes your reactive BloCs to the UI Layer.
2. [rx_bloc_test](https://pub.dev/packages/rx_bloc_test) that facilitates implementing the unit tests for your BloCs
3. [rx_bloc_generator](https://pub.dev/packages/rx_bloc_generator) that boosts development efficiency by making your BloCs zero-boilerplate.

# Why rx_bloc ?
If you are working on a complex project you might be challenged to build a highly interactive UI or a heavy business logic in a combination with the consumption of various data sources such as REST APIs, Web Socket, Secured Storage, Shared Preferences, etc. To achieve this, you might need a neet architecture that facilitates your work during product development.

# Usage
By definition, the BloC layer should contain only the business logic of your app. This means that it should be fully decoupled from the UI layer and should be loosely coupled with the data layer through Dependency Injection. The **UI** layer can send **events** to the BloC layer and can listen for **state** changes.

## Events
As you can see below, all events are just pure methods declared in one abstract class (CounterBlocEvents).
```dart
/// A contract, containing all Counter BloC events
abstract class CounterBlocEvents {
  /// Increment the count
  void increment();

  /// Decrement the count
  void decrement();
}
```
This way, we can push events to the BloC by simply invoking those methods from the UI layer as follows:
```dart
RaisedButton(
    onPressed: () => bloc.events.increment(),
    ...
) 
```

## States
The same way as with the events, now you can see that we have declarations for multiple states grouped in one abstract class (CounterBlocStates). Depending on your goals, you can either have just one stream with all needed data or you can split it into individual streams. In the latter case, you can apply the [Single-responsibility principle](https://en.wikipedia.org/wiki/Single-responsibility_principle) or any performance optimizations.

```dart
/// A contract, containing all Counter BloC states
abstract class CounterBlocStates {
  /// The count of the Counter
  ///
  /// It can be controlled by executing
  /// [CounterBlocEvents.increment] and
  /// [CounterBlocEvents.decrement]
  ///
  Stream<int> get count;

  /// Loading state
  Stream<bool> get isLoading;

  /// User friendly error messages
  Stream<String> get errors;
}
```

## Zero-boilerplate BloC

Once we have defined the states and events contracts, it’s time to implement the actual Counter BloC, where the business logic of the main feature of the app will reside. As mentioned previously, we are armed with rx_bloc_generator, which should be added to your pubspec.yaml file as follows:

```dart
dev_dependencies:
  build_runner:
  rx_bloc_generator:^1.0.1
```

# RxBloc example project

This example shows how properly to use the [RxBloc package](https://github.com/Prime-Holding/RxBloc) in combination with [FlutterRxBloc](https://github.com/Prime-Holding/FlutterRxBloc) and [RxBlocGenerator](https://github.com/Prime-Holding/RxBlocGenerator) and make use of their features in order to speed up and optimise the workflow. This library also uses reactive streams from the package [rxdart](https://pub.dev/packages/rxdart).

## BLoC Generation

When working on a screen, most of the times it can become frustrating when the code for ui gets interlaced with the logic of the app. To prevent this, a lot of solutions have been invented, and one of them is exactly the BLoC Pattern. With it the logic of the screen resides in one specific place (the BLoC) which communicates with the screen and provides input and output to manipulate data that is presented. _**RxBloc**_ is one example of this.

To create a bloc, we annotate a class with the *@RxBloc* annotation. This annotation is used to notify the generator that we create everything needed for our bloc in the background by the name of the class we annotated. Additionally, in order to generate the BLoC, we'll need two additional **abstract** classes that will serve as input (events) and output (states). Each of these classes should have the same name as the bloc with the addition of 'Events' or 'States' appended at the end. Later on we can use these to define additional behaviours of the bloc.

```dart
// All input events will be defined here
abstract class DivisionBlocEvents{}

// All output states will be defined here
abstract class DivisionBlocStates{}

@RxBloc()
class DivisionBloc extends $DivisionBloc {
// Bloc specific logic goes here
}
```

We can also see that our DivisionBloc class also **extend**s from a class with the same name but with a dollar sign in front. This class is generated automatically when running the `flutter packages pub run build_runner build` command from the terminal (in order for this class to be generated, make sure you have added the latest `rx_bloc_generator` to your `dev_dependencies` in pubspec.yaml file). When the code generation has finished, we'll have a new file with the extension `.rxb.g.dart` which we will need to include in our file where we created the bloc. Additionaly, we may want to include two imports in order to fix any errors that arose.

```dart
import 'package:rxdart/rxdart.dart'; // Uses streams and their extensions to implement custom behaviours
import 'package:rx_bloc/rx_bloc.dart'; // Used for annotations and base bloc structure

part 'division_bloc.rxb.g.dart';

// All input events will be defined here
abstract class DivisionBlocEvents{}

// All output states will be defined here
abstract class DivisionBlocStates{}

@RxBloc()
class DivisionBloc extends $DivisionBloc {
// Bloc specific logic goes here
}
```

After that, we'd define additional events and states in the appropriate 'Events' and 'States' classes. Events class should contain only method definitions that will be used as events for passing data to the bloc, while the states class is used for listening to the outputs of the bloc via streams. Events and states can have annotations that will modify the generation of the code (read more about the annotations [here](https://github.com/Prime-Holding/RxBlocGenerator)). After defining states and events, re-run the code generation once again and you're free to go with defining additional behaviours.

```dart
import 'package:rxdart/rxdart.dart'; // Uses streams and their extensions to implement custom behaviours
import 'package:rx_bloc/rx_bloc.dart'; // Used for annotations and base bloc structure

part 'division_bloc.rxb.g.dart';

// All input events will be defined here
abstract class DivisionBlocEvents{
// Event that we use for number division
  @RxBlocEvent(
      type: RxBlocEventType.behaviour,
      seed: _DivideNumbersEventArgs(a: '1.0', b: '1.0'))
  void divideNumbers(String a, String b);
}

// All output states will be defined here
abstract class DivisionBlocStates{
// The output string of the division
  Stream<String> get divisionResult;

  // The loading state of the current division
  @RxBlocIgnoreState()
  Stream<bool> get isLoading;

  // The error state where all thrown exceptions are served
  @RxBlocIgnoreState()
  Stream<String> get errors;
}

@RxBloc()
class DivisionBloc extends $DivisionBloc {
// Bloc specific logic goes here
}
```
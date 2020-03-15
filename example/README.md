# Example Usage - RxBlocListener

```dart
RxBlocListener<CounterBlocType, String>( // Specify the type of the bloc and its state
    state: (bloc) => bloc.states.infoMessage, // pick a specific state you want to listen for
    listener: (context, state) => 
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(state))) // Listen for the state you have specified above
)
```

# Example user - RxBlocBuilder

```dart
RxBlocBuilder<CounterBlocType, bool>( // Specify the type of the bloc and its state
    state: (bloc) => bloc.states.decrementEnabled, // pick a specific state you want to listen
    builder: (context, snapshot, bloc) => RaisedButton(
        child: Text('Do some action'),
        onPressed: (snapshot.data ?? false) ? bloc.events.decrement : null,
   ),
)
```
### UI Integration tests using Flutter Driver
Integration tests work as a pair: first, deploy an instrumented application to a real device or emulator and then “drive” the application from a separate test suite, checking to make sure everything is correct along the way.

To create this test pair, use the flutter_driver package. It provides tools to create instrumented apps and drive those apps from a test suite

For more information and how-to check:
- [UI Integration Tests](/doc/ui_integration_tests.md)
- [Full tutorial](https://www.youtube.com/playlist?list=PL6tu16kXT9PrzZbUTUscEYOHHTVEKPLha "Full tutorial")


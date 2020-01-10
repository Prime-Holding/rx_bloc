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
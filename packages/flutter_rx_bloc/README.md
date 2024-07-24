![CI](https://github.com/Prime-Holding/rx_bloc/workflows/CI/badge.svg) [![codecov](https://codecov.io/gh/Prime-Holding/rx_bloc/graph/badge.svg?token=BHQD4QC463)](https://codecov.io/gh/Prime-Holding/rx_bloc) ![style](https://img.shields.io/badge/style-effective_dart-40c4ff.svg) ![license](https://img.shields.io/badge/license-MIT-purple.svg)

A Flutter package that helps implement the BLoC Design Pattern using the power of reactive streams.

This package is built to work with [rx_bloc](https://pub.dev/packages/rx_bloc) and [rx_bloc_generator](https://pub.dev/packages/rx_bloc_generator)


## Bloc Widgets

**RxBlocBuilder** is a Flutter widget that requires a `RxBloc`, a `builder` and a `state`  function. `RxBlocBuilder` handles building the widget in response to new states. `RxBlocBuilder` is very similar to `StreamBuilder` but has a more simple API to reduce the amount of boilerplate code needed. 

* The `builder` function will potentially be called many times and should be a [pure function](https://en.wikipedia.org/wiki/Pure_function) that returns a widget in response to the state.
* The `state` function determines which exact state of the bloc will be used. 
* If the `bloc` parameter is omitted, `RxBlocBuilder` will automatically perform a lookup using `RxBlocProvider` and the current `BuildContext`.

**RxBlocMultiBuilder2** is a Flutter widget that requires a `RxBloc`, a `builder`, a `state1` and a `state2` functions. `RxBlocMultiBuilder2` handles building the widget in response to new states. `RxBlocMultiBuilder2` is very similar to `StreamBuilder` but has a more simple API to reduce the amount of boilerplate code needed.

* The `builder` function will potentially be called many times and should be a [pure function](https://en.wikipedia.org/wiki/Pure_function) that returns a widget in response to the state.
* The `state1` and `state2` functions determine which states of the bloc will be used.
* If the `bloc` parameter is omitted, `RxBlocMultiBuilder2` will automatically perform a lookup using `RxBlocProvider` and the current `BuildContext`.

**RxBlocMultiBuilder3** is a Flutter widget that requires a `RxBloc`, a `builder`, a `state1`, `state2` and a `state3` functions. `RxBlocMultiBuilder3` handles building the widget in response to new states. `RxBlocMultiBuilder3` is very similar to `StreamBuilder` but has a more simple API to reduce the amount of boilerplate code needed.

* The `builder` function will potentially be called many times and should be a [pure function](https://en.wikipedia.org/wiki/Pure_function) that returns a widget in response to the state.
* The `state1`, `state2` and `state3` functions determine which states of the bloc will be used.
* If the `bloc` parameter is omitted, `RxBlocMultiBuilder3` will automatically perform a lookup using `RxBlocProvider` and the current `BuildContext`.

See `RxBlocListener` if you want to "do" anything in response to state changes such as navigation, showing a dialog, etc...


```dart
RxBlocBuilder<NewsBlocType, List<News>>( // At the first placeholder define what bloc you need, at the second define what type will be the state you want to listen. It needs to match the type of the stream in the state function below.
  state: (bloc) => bloc.states.news, // Determine which exact state of the bloc will be used for building the widget below. 
  builder: (context, state, bloc) {
    // return widget here based on BlocA's state
  }
)
```

```dart
RxBlocMultiBuilder2<NewsBlocType, List<BreakingNews>, List<News>>( // At the first placeholder define what bloc you need, after that define what type will be the states you want to listen to. They need to match the type of the streams in the state functions below.
  state1: (bloc) => bloc.states.breakingNews, // Determine which exact states of the bloc will be used for building the widget below. 
  state2: (bloc) => bloc.states.news,
  builder: (context, breakingNews, news, bloc) {
    // return widget here based on the Bloc's states
  }
)
```

```dart
RxBlocMultiBuilder3<NewsBlocType, List<BreakingNews>, List<News>, List<TopStory>>( // At the first placeholder define what bloc you need, after that define what type will be the states you want to listen to. They need to match the type of the streams in the state functions below.
  state1: (bloc) => bloc.states.breakingNews, // Determine which exact states of the bloc will be used for building the widget below. 
  state2: (bloc) => bloc.states.news,
  state3: (bloc) => bloc.states.topStories,
  builder: (context, breakingNews, news, topStories, bloc) {
    // return widget here based on the Bloc's states
  }
)
```

Only specify the bloc if you wish to provide a bloc that will be scoped to a single widget and isn't accessible via a parent `RxBlocProvider` and the current `BuildContext`.

```dart
RxBlocBuilder<NewsBlocType, List<News>>(
  bloc: blocA, // provide the local bloc instance
  state: (bloc) => bloc.states.news, // Determine which exact state of the bloc will be used for building the widget below.
  builder: (context, state, bloc) {
    // return widget here based on BlocA's state
  }
)
```

**RxResultBuilder** is a Flutter widget which requires a `state` function, a set of callbacks `buildSuccess`, `buildError` and `buildLoading`, and an optional `RxBloc`. `RxResultBuilder` is similar to `RxBlocBuilder`, however it is meant as an easier way to handle `Result` states.

* The `buildSuccess`, `buildError` and `buildLoading` functions will potentially be called many times and should be [pure functions](https://en.wikipedia.org/wiki/Pure_function) that return a widget in response to the state.
* The `state` function determines which exact state of the bloc will be used. 
* If the `bloc` parameter is omitted, `RxResultBuilder` will automatically perform a lookup using `RxBlocProvider` and the current `BuildContext`.

```dart
/// At the first placeholder define what bloc you need, at the second define the type of the [Result] state you want to listen to.
/// It needs to match the type of the stream in the state function below.
RxResultBuilder<NewsBlocType, List<News>>( 
/// Determine which exact state of the bloc will be used for building the widget below. 
/// In this case the stream [bloc.states.news] should have a type of [Stream<Result<List<News>>>]
  state: (bloc) => bloc.states.news, 
  buildSuccess: (context, data, bloc) {
    ///here return a widget based on the data from the [Result]
  },
  buildLoading: (context, bloc) {
    ///here return a widget showing that we are waiting for the data, e.g. loading indicator
  },
  buildError: (context, error, bloc) {
    ///here return a widget showing what went wrong 
  },
)
```

Only specify the bloc if you wish to provide a bloc that will be scoped to a single widget and isn't accessible via a parent `RxBlocProvider` and the current `BuildContext`.

```dart
RxResultBuilder<NewsBlocType, List<News>>(
  bloc: blocA, // provide the local bloc instance
  state: (bloc) => bloc.states.news, // Determine which exact state of the bloc will be used for building the widget below.
  ...
)
```

**RxBlocProvider** is a Flutter widget which provides a bloc to its children via `RxBlocProvider.of<T>(context)`. It is used as a dependency injection (DI) widget so that a single instance of a bloc can be provided to multiple widgets within a subtree.

In most cases, `RxBlocProvider` should be used to create new `blocs` which will be made available to the rest of the subtree. In this case, since `RxBlocProvider` is responsible for creating the bloc, it will automatically handle closing the bloc.

```dart
RxBlocProvider<BlocAType>(
  create: (BuildContext context) => BlocA(),
  child: ChildA(),
);
```

In some cases, `RxBlocProvider` can be used to provide an existing bloc to a new portion of the widget tree. This will be most commonly used when an existing `bloc` needs to be made available to a new route. In this case, `RxBlocProvider` will not automatically close the bloc since it did not create it.

```dart
RxBlocProvider<BlocAType>.value(
  value: RxBlocProvider.of<BlocAType>(context),
  child: ScreenA(),
);
```

then from either `ChildA`, or `ScreenA` we can retrieve `BlocA` with:

```dart
RxBlocProvider.of<BlocAType>(context)
```

**RxMultiBlocProvider** is a Flutter widget that merges multiple `RxBlocProvider` widgets into one.
`RxMultiBlocProvider` improves the readability and eliminates the need to nest multiple `RxBlocProviders`.
By using `RxMultiBlocProvider` we can go from:

```dart
RxBlocProvider<BlocAType>(
  create: (BuildContext context) => BlocA(),
  child: RxBlocProvider<BlocBType>(
    create: (BuildContext context) => BlocB(),
    child: RxBlocProvider<BlocCType>(
      create: (BuildContext context) => BlocC(),
      child: ChildA(),
    )
  )
)
```

to:

```dart
RxMultiBlocProvider(
  providers: [
    RxBlocProvider<BlocAType>(
      create: (BuildContext context) => BlocA(),
    ),
    RxBlocProvider<BlocBType>(
      create: (BuildContext context) => BlocB(),
    ),
    RxBlocProvider<BlocCType>(
      create: (BuildContext context) => BlocC(),
    ),
  ],
  child: ChildA(),
)
```

**RxBlocListener** is a Flutter widget which takes a `RxBlocWidgetListener` and an optional `RxBloc` and invokes the `listener` in response to state changes in the bloc. It should be used for functionality that needs to occur once per state change such as navigation, showing a `SnackBar`, showing a `Dialog`, etc...

`listener` is only called once for each state change (**NOT** including `initialState`) unlike `builder` in `RxBlocBuilder` and is a `void` function.

If the bloc parameter is omitted, `RxBlocListener` will automatically perform a lookup using `RxBlocProvider` and the current `BuildContext`.

```dart
RxBlocListener<NewsBlocType, bool>( // Specify the type of the bloc and its state type
    state: (bloc) => bloc.states.isLoading, // pick a specific state you want to listen for
    listener: (context, state) {
      // do stuff here based on NewsBloc's state
    }
)
```

Only specify the bloc if you wish to provide a bloc that is otherwise not accessible via `BlocProvider` and the current `BuildContext`.

```dart
RxBlocListener<NewsBlocType, bool>( // Specify the type of the bloc and its state type
    bloc: bloc,
    state: (bloc) => bloc.states.isLoading, // pick a specific state you want to listen for
    listener: (context, state) {
      // do stuff here based on NewsBloc's state
    }
)
```

If you want fine-grained control over when the listener function is called you can provide an optional `condition` to `RxBlocListener`. The `condition` takes the previous bloc state and current bloc state and returns a boolean. If `condition` returns true, `listener` will be called with `state`. If `condition` returns false, `listener` will not be called with `state`.

```dart
RxBlocListener<BlocAType, bool>(
  state: (bloc) => bloc.states.isLoading, // pick a specific state you want to listen for
  condition: (previousState, state) {
    // return true/false to determine whether or not
    // to call listener with state
  },
  listener: (context, state) {
    // do stuff here based on BlocA's state
  }
  child: Container(),
)
```

## Usage

Lets take a look at how to use `RxBlocBuilder` to hook up a `CounterPage` widget to a `CounterBloc`.

### CounterBloc
```dart
/// This BloC and its event and state contracts usually
/// resides in counter_bloc.dart

/// A contract class containing all events.
abstract class CounterBlocEvents {
  /// Increment the count
  void increment();

  /// Decrement the count
  void decrement();
}

/// A contract class containing all states for our multi state BloC.
abstract class CounterBlocStates {
  /// The count of the Counter
  ///
  /// It can be controlled by executing [CounterBlocEvents.increment] and
  /// [CounterBlocEvents.decrement]
  ///
  Stream<int> get count;

  /// Loading state
  Stream<bool> get isLoading;

  /// Error messages
  Stream<String> get errors;
}

/// A BloC responsible for count calculations
@RxBloc()
class CounterBloc extends $CounterBloc {
  /// Default constructor
  CounterBloc(this._repository);

  final CounterRepository _repository;

  /// Map increment and decrement events to `count` state
  @override
  Stream<int> _mapToCountState() => Rx.merge<Result<int>>([
        // On increment.
        _$incrementEvent
            .flatMap((_) => _repository.increment().asResultStream()),
        // On decrement.
        _$decrementEvent
            .flatMap((_) => _repository.decrement().asResultStream()),
      ])
          // This automatically handles the error and loading state.
          .setResultStateHandler(this)
          // Provide success response only.
          .whereSuccess()
          //emit 0 as initial value
          .startWith(0);

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((Exception error) => error.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
```

### CounterWidget
```dart
class CounterWidget extends StatelessWidget {
  const CounterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter widget')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RxBlocListener<CounterBlocType, String>(
              state: (bloc) => bloc.states.errors,
              listener: (context, errorMessage) =>
                  ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage ?? 'Unknown error'),
                  behavior: SnackBarBehavior.floating,
                ),
              ),
            ),
            RxBlocBuilder<CounterBlocType, int>(
              state: (bloc) => bloc.states.count,
              builder: (context, snapshot, bloc) => snapshot.hasData
                  ? Text(
                      snapshot.data.toString(),
                      style: Theme.of(context).textTheme.headline4,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildActionButtons(),
    );
  }

  Widget _buildActionButtons() => RxBlocBuilder<CounterBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, loadingState, bloc) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (loadingState.isLoading)
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: CircularProgressIndicator(),
              ),
            FloatingActionButton(
              backgroundColor: loadingState.buttonColor,
              onPressed: loadingState.isLoading ? null : bloc.events.increment,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              backgroundColor: loadingState.buttonColor,
              onPressed: loadingState.isLoading ? null : bloc.events.decrement,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      );
}
```

## Rx Form Field Builder Widgets

**RxFormFieldBuilder** is a convenience widget, which makes it easier to build and update responsive form fields with reactive Streams.

This is an example of a drop down menu form field.

```dart
Widget build(BuildContext context) =>
    RxFormFieldBuilder<ColorSelectionBlocType, ColorEnum>(
      state: (bloc) => bloc.states.color,
      showErrorState: (bloc) => bloc.states.showErrors,
      builder: (fieldState) => Column(
        children: [
          Center(
            child: DropdownButton<ColorEnum>(
              value: fieldState.value,
              onChanged: fieldState.bloc.events.setColor,
              items: ColorEnum.values
                  .map(
                    (color) => DropdownMenuItem<ColorEnum>(
                      value: color,
                      child: Text(
                        color.toString(),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          //show errors, say for instance the user tries to save the
          //changes to the form, but they forgot to select a color.
          if (fieldState.showError)
            Row(
              children: [
                Text(
                  fieldState.error,
                ),
              ],
            ),
        ],
       ),
    );
```

**RxTextFormFieldBuilder** specializes in building text form fields with reactive streams, it handles the most important parts of managing a text field's state.

This example shows general use.

```dart
Widget build(BuildContext context) =>
  RxTextFormFieldBuilder<EditProfileBlocType>(
    state: (bloc) => bloc.states.name,
    showErrorState: (bloc) => bloc.states.showErrors,
    onChanged: (bloc, value) => bloc.events.setName(value),
    builder: (fieldState) => TextFormField(
      //use the controller from the fieldState
      controller: fieldState.controller,
      //copy the decoration generated by the builder widget, which
      //contains stuff like when to show errors, with additional
      //decoration
      decoration: fieldState.decoration
          .copyWithDecoration(InputStyles.textFieldDecoration),
    ),
  );
```

This example shows how to create a password field.

```dart
Widget build(BuildContext context) =>
  RxTextFormFieldBuilder<LoginBlocType>(
    state: (bloc) => bloc.states.password,
    showErrorState: (bloc) => bloc.states.showErrors,
    onChanged: (bloc, value) => bloc.events.setPassword(value),
    decorationData: InputStyles.passwordFieldDecorationData, //optional extra decoration for the field
    obscureText: true, //tell the password field that it should be obscured
    builder: (fieldState) => TextFormField(
      //use the controller from the fieldState
      controller: fieldState.controller,
      //use the isTextObscured field from fieldState to determine
      //when the text should be obscured. The isTextObscured field
      //automatically changes in response to taps on the suffix icon.
      //how the suffix icon looks is determined by the iconVisibility
      //and iconVisibilityOff properties of the decorationData.
      obscureText: fieldState.isTextObscured,
      //copy the decoration generated by the builder widget, which
      //contains stuff like when to show errors, with additional
      //decoration
      decoration: fieldState.decoration
          .copyWithDecoration(InputStyles.passwordFieldDecoration),
    ),
  );
```

The following example shows how to create a type ahead field:  
  
### TypeAheadPage

```dart
class TypeAheadFormPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              RxTextFormFieldBuilder<TypeAheadBlocType>(
                state: (bloc) => bloc.states.choice,
                showErrorState: (bloc) => bloc.states.showErrors,
                onChanged: (bloc, value) => bloc.events.findLike(value),
                //we change the cursor behavior so that it doesn't jump
                //to the beginning of the text field when we choose
                cursorBehaviour: RxTextFormFieldCursorBehaviour.end,
                builder: (fieldState) => TextFormField(
                  controller: fieldState.controller,
                  decoration: fieldState.decoration,
                ),
              ),
              RxBlocBuilder<TypeAheadBlocType, List<String>>(
                state: (bloc) => bloc.states.choices,
                builder: (context, snapshot, bloc) => ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: max(1, (snapshot.data ?? const []).length),
                    itemBuilder: (context, index) =>
                        (snapshot.data ?? []).isEmpty
                            ? const ListTile(
                                title: Text(
                                  'No results for that query',
                                ),
                              )
                            : GestureDetector(
                                onTap: () => bloc.events.choose(snapshot.data![index]),
                                child: ListTile(
                                  title: Text(
                                    snapshot.data![index],
                                  ),
                                ),
                              ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      
}
```

### TypeAheadBloc

```dart
abstract class TypeAheadBlocEvents {
  void findLike(String like);

  void choose(String choice);
}

abstract class TypeAheadBlocStates {
  Stream<String> get choice;

  Stream<List<String>> get choices;

  Stream<bool> get showErrors;
}

@RxBloc()
class TypeAheadBloc extends $TypeAheadBloc {
  SelectionBoxBloc(this.repository);

  final SelectionBoxRepository repository;

  @override
  Stream<String> _mapToChoiceState() => MergeStream([
        _$findLikeEvent,
        _$chooseEvent,
      ]).shareReplay(maxSize: 1);

  @override
  Stream<List<String>> _mapToChoicesState() => choice
      .switchMap((like) => repository.findLike(like).asStream())
      .shareReplay(maxSize: 1);

  @override
  Stream<bool> _mapToShowErrorsState() => BehaviorSubject.seeded(false);
}
```

## UI Integration tests using Flutter Driver

Integration tests work as a pair: first, deploy an instrumented application to a real device or emulator and then “drive” the application from a separate test suite, checking to make sure everything is correct along the way.

To create this test pair, use the flutter_driver package. It provides tools to create instrumented apps and drive those apps from a test suite

For more information and how-to check:
- [UI Integration Tests](doc/ui_integration_tests.md)
- [Full tutorial](https://www.youtube.com/playlist?list=PL6tu16kXT9PrzZbUTUscEYOHHTVEKPLha "Full tutorial")

## FAQ

### What is the main advantage of [rx_bloc](https://pub.dev/packages/rx_bloc)

* Comparing with the other libraries facilitating the BloC Pattern, [rx_bloc](https://pub.dev/packages/rx_bloc) supports multiple output streams (states) per BloC. As shown in the example above, CounterBlocStates consist of four different states, as each of them do its specific job. 
 1. **count** shows the current count
 2. **incrementEnabled** manages enable/disable state of the increment button
 3. **decrementEnabled** manages enable/disable state of the decrement button
 4. **infoMessage** shows info message 

Doing so, the BloC it's not overloaded and follows [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single_responsibility_principle)


### On what package is based [flutter_rx_bloc](https://pub.dev/packages/flutter_rx_bloc)

* [flutter_rx_bloc](https://pub.dev/packages/flutter_rx_bloc) is based on the well known [flutter_bloc](https://github.com/felangel/bloc/tree/master/packages/flutter_bloc) made by [Felix Angelov](https://github.com/felangel)


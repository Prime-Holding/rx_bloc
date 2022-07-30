![CI][ci_badge_lnk] [![codecov][codecov_badge_lnk]][codecov_branch_lnk] ![style][code_style_lnk] ![license][license_lnk]

# What is rx_bloc ?
![Slogan][rx_bloc_slogan_lnk]

Along with the [rx_bloc][rx_bloc_lnk] the following set of packages will help you during the product development.
1. [flutter_rx_bloc][flutter_rx_bloc_lnk] that exposes your reactive BloCs to the UI Layer.
2. [rx_bloc_test][rx_bloc_test_lnk] that facilitates implementing the unit tests for your BloCs
3. [rx_bloc_generator][rx_bloc_generator_lnk] that boosts development efficiency by making your BloCs zero-boilerplate.
4. [rx_bloc_list][rx_bloc_list_lnk] that facilitates implementing infinity scroll and pull-to-refresh features with minimal setup.
5. [rx_bloc_cli][rx_bloc_cli_lnk] which helps you bootstrap fully functional and feature-rich projects in seconds.

# Why rx_bloc ?
If you are working on a complex project you might be challenged to build a highly interactive UI or a heavy business logic in a combination with the consumption of various data sources such as REST APIs, Web Socket, Secured Storage, Shared Preferences, etc. To achieve this, you might need a sophisticated architecture that facilitates your work during product development.

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
The same way as with the events, now you can see that we have declarations for multiple states grouped in one abstract class (CounterBlocStates). Depending on your goals, you can either have just one stream with all needed data or you can split it into individual streams. In the latter case, you can apply the [Single-responsibility principle][single_responsibility_principle_lnk] or any performance optimizations.

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

Then you need to create a CounterBloc class in **counter_bloc.dart** (just after the contracts) as shown below
[counter_bloc.dart][counter_bloc_example_line_ref]
```dart
...
@RxBloc()
class CounterBloc extends $CounterBloc {}
```

### Android Studio Plugin

You can create the contracts along with the BloC class by yourself, but this seems to be a tedious task, isn't it? It's recommended using the [RxBloC Plugin for Android Studio][android_studio_rx_bloc_plugin_lnk] that helps effectively creating reactive BloCs.
[![Android Plugin][android_studio_rx_bloc_plugin_preview_lnk]][android_studio_rx_bloc_plugin_lnk]


By selecting `New` -> `RxBloc Class` the plugin will create the following files
* `${name}_bloc.dart` The file, where the business logic resides (the contracts (events and states) along with the BloC itself).
* `${name}_bloc.rxb.g.dart` The file, where all boring bolerplate code (`$CounterBloc` and `CounterBlocType`) resides.

### Generator

The plugin creates just the initial state of the BloC. For all further updates, you will need a tool, which will be updating the generated file (`${name}_bloc.rxb.g.dart`) based on your needs.
Here is where the [rx_bloc_generator][rx_bloc_generator_lnk] package helps, as automatically writes all the boring boilerplate code so you can focus on your business logic instead. You just need to add it to your pubspec.yaml file as follows:


```dart
dev_dependencies:
  build_runner: ^2.0.3
  rx_bloc_generator: any
```

Once added to the `pubspec.yaml`, run the flutter command for getting the newly added dependencies `flutter pub get`, and then just start the generator by execuing this command `flutter packages pub run build_runner watch --delete-conflicting-outputs`.


### Implementing the business logic
[counter_bloc.dart][counter_bloc_example_line_ref]
```dart
...
/// A BloC responsible for count calculations
@RxBloc()
class CounterBloc extends $CounterBloc {
  /// The default constructor injecting a repository through DI
  CounterBloc(this._repository);
  
  /// The repository used for data source communication
  final CounterRepository _repository;

  /// Map increment and decrement events to the `count` state
  @override
  Stream<int> _mapToCountState() => Rx.merge<Result<int>>([
            // On increment
            _$incrementEvent.flatMap((_) =>
                _repository.increment().asResultStream()),
            // On decrement
            _$decrementEvent.flatMap((_) => 
                _repository.decrement().asResultStream()),
        ])
        // This automatically handles the error and loading state.
        .setResultStateHandler(this)
        // Provide "success" response only.
        .whereSuccess()
        //emit 0 as an initial value
        .startWith(0);
    
  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((error) => error.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
```
As you can see, by extending [$CounterBloc][abstract_counter_bloc_ref], we must implement `Stream<int>` `_mapToCountState()` , which is the method responsible for the events-to-state business logic. Furthermore, we have [_$incrementEvent][increment_event_example_line_ref] and [_$decrementEvent][decrement_event_example_line_ref], which are the [subjects][rxdart_subjects_lnk] where the events will flow when [increment()][increment_event_method_example_line_ref] and [decrement()][decrement_event_method_example_line_ref] methods are invoked from the UI Layer.
In the code above we declare that as soon as the user taps on the increment or decrement button, an API call will be executed. Since both _$incrementEvent and _$decrementEvent are grouped in one stream by the merge operator, the result of their API calls allows us to register our BloC as a state handler. For more information what is State Handler and how it works, look at [this article][intro_to_rx_bloc_pt_2_lnk]. We then extract only the “success” result and finally put an initial value of 0.

## Accessing the BloC from the widget tree
First, make sure you have added [flutter_rx_bloc][flutter_rx_bloc_lnk] to your pubspec.yaml file and after exexuting `flutter pub get` you will have access to the following `widget` binders.

```dart
dependencies:
  flutter_rx_bloc: any
```

[RxBlocProvider][rx_bloc_provider_lnk] is a Flutter widget that provides a BloC to its children via RxBlocProvider.of<T>(context). It is used as a dependency injection (DI) widget so that a single instance of a BloC can be provided to multiple widgets within a subtree.
  
```dart
MaterialApp(
    ...
    home: RxBlocProvider<CounterBlocType>(
        create: (context) => CounterBloc(CounterRepository()),
        child: const HomePage(),
    ),
);
```
[RxBlocBuilder][rx_bloc_builder_lnk] is a Flutter widget that requires a RxBloc, a builder, and a state function. RxBlocBuilder handles building the widget in response to new states. RxBlocBuilder is very similar to StreamBuilder but has a more simple API to reduce the amount of boilerplate code needed.
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    Scaffold(
      ...
      RxBlocBuilder<CounterBlocType, int>(
        state: (bloc) => bloc.states.count,
        builder: (context, snapshot, bloc) => 
          snapshot.hasData ? 
            Text(snapshot.data.toString()): 
            Container()
  )
}
```

## Presentations
[![HackConf][hack_conf_img]][hack_conf_link]  
  
## Video tutorials
  
- [Building feature-rich lists in Flutter](https://youtu.be/Nc8OLxYhQ0w) A feature-rich ListView implementation in Flutter that demonstrates how easy it is to build common functionalities such as `pull-to-refresh` and `infinite-scroll`.
- [Building Github Search in Flutter](https://youtu.be/qhsSLY0wSwQ) Under ten minutes you will learn how a Github search can be built in Flutter.

  
## Samples

- [Booking app][booking_app_sample_lnk] - A booking app that solves various tech challenges such as: Content lazy loading, Slick animations, Composite filters, Inter-feature communication, Complete error handling and more.
- [Favorites Advanced][favourites_advanced_sample_lnk] - an advanced favorites app that showcase multiple software development challenges.
- [Github search][github_search_example_line_ref] - a feature-rich list view including infinity-scroll and pull-to-refresh functionalities.
- [Counter][counter_bloc_sample_lnk] - an example of how to create a `CounterBloc` to implement an advanced Flutter Counter app.
- [Division][division_sample_lnk] - Division sample

  

## Articles

- [Introducing rx_bloc ecosystem - Part 1][intro_to_rx_bloc_pt_1_lnk] A set of Flutter packages that help implement the BloC (Business Logic Component) design pattern using the power of reactive streams.
- [Introducing rx_bloc ecosystem - Part 2][intro_to_rx_bloc_pt_2_lnk] Dart package that helps implementing the BLoC (Business Logic Component) Design Pattern using the power of the reactive streams.
- [Introducing rx_bloc ecosystem - Part 3][intro_to_rx_bloc_pt_3_lnk] Set of Flutter Widgets that expose your reactive BloCs to the UI Layer.
- [RxBloc IntelliJ Plugin][rx_bloc_intellij_plugin_lnk] - A plugin that helps you create reactive BloCs faster and smoother.
- [Easy paginated lists in Flutter][paginated_lists_article_lnk] - Implementing infinity scroll and pull-to-refresh in your app was never so easy.
- [Bootstrapping Your Flutter App With Ease][rx_bloc_cli_article_lnk] - Setting up and configuring new projects can be a tedious task. However rx_bloc_cli is here to help!
- [Building complex apps in Flutter through the power of reactive programming][reactive_programming_in_flutter_article_lnk] - Implementing complex apps as satisfying the user expectations along with consuming a fragmented API could be challenging nowadays. Learn how you can overcome some of the most common challenges you might face.
- [Building Forms in Flutter][building_forms_in_flutter_article_lnk] - Although building forms in Flutter may seem like an easy task, separating the business logic from the UI layer can be a challenge. The separation of concerns makes your app more scalable and maintainable and most importantly the business (validation) logic becomes unit-testable, so let’s see how we can achieve this by using rx_bloc and flutter_rx_bloc.

[ci_badge_lnk]: https://github.com/Prime-Holding/rx_bloc/workflows/CI/badge.svg
[codecov_badge_lnk]: https://codecov.io/gh/Prime-Holding/rx_bloc/branch/develop/graph/badge.svg
[codecov_branch_lnk]: https://codecov.io/gh/Prime-Holding/rx_bloc/branch/develop
[code_style_lnk]: https://img.shields.io/badge/style-effective_dart-40c4ff.svg
[license_lnk]: https://img.shields.io/badge/license-MIT-purple.svg
[rx_bloc_slogan_lnk]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc/doc/asset/slogan.png
[hack_conf_img]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc/doc/asset/hack_conf.png
[hack_conf_link]: https://youtu.be/nVX4AzeuVu8  
[rx_bloc_lnk]: https://pub.dev/packages/rx_bloc
[flutter_rx_bloc_lnk]: https://pub.dev/packages/flutter_rx_bloc
[rx_bloc_test_lnk]: https://pub.dev/packages/rx_bloc_test
[rx_bloc_generator_lnk]: https://pub.dev/packages/rx_bloc_generator
[rx_bloc_list_lnk]: https://pub.dev/packages/rx_bloc_list
[rx_bloc_cli_lnk]: https://pub.dev/packages/rx_bloc_cli
[single_responsibility_principle_lnk]: https://en.wikipedia.org/wiki/Single-responsibility_principle
[counter_bloc_example_line_ref]: https://github.com/Prime-Holding/rx_bloc/blob/a1854040f1d693af5304bce7a5c2fa68c5809ecf/examples/counter/lib/bloc/counter_bloc.dart#L33
[github_search_example_line_ref]: https://github.com/Prime-Holding/rx_bloc/tree/master/examples/github_search/lib/feature_github_repo_list
[android_studio_rx_bloc_plugin_lnk]: https://plugins.jetbrains.com/plugin/16165-rxbloc?preview=true
[android_studio_rx_bloc_plugin_preview_lnk]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc/doc/asset/android_plugin.png
[abstract_counter_bloc_ref]: https://github.com/Prime-Holding/rx_bloc/blob/a1854040f1d693af5304bce7a5c2fa68c5809ecf/examples/counter/lib/bloc/counter_bloc.rxb.g.dart#L20
[increment_event_example_line_ref]: https://github.com/Prime-Holding/rx_bloc/blob/a1854040f1d693af5304bce7a5c2fa68c5809ecf/examples/counter/lib/bloc/counter_bloc.dart#L44
[decrement_event_example_line_ref]: https://github.com/Prime-Holding/rx_bloc/blob/a1854040f1d693af5304bce7a5c2fa68c5809ecf/examples/counter/lib/bloc/counter_bloc.dart#L47
[rxdart_subjects_lnk]: https://pub.dev/documentation/rxdart/latest/rx_subjects/rx_subjects-library.html
[increment_event_method_example_line_ref]: https://github.com/Prime-Holding/rx_bloc/blob/a1854040f1d693af5304bce7a5c2fa68c5809ecf/examples/counter/lib/bloc/counter_bloc.dart#L10
[decrement_event_method_example_line_ref]: https://github.com/Prime-Holding/rx_bloc/blob/a1854040f1d693af5304bce7a5c2fa68c5809ecf/examples/counter/lib/bloc/counter_bloc.dart#L13
[rx_bloc_provider_lnk]: https://pub.dev/documentation/flutter_rx_bloc/latest/flutter_rx_bloc/RxBlocProvider-class.html
[rx_bloc_builder_lnk]: https://pub.dev/documentation/flutter_rx_bloc/latest/flutter_rx_bloc/RxBlocBuilder-class.html
[booking_app_sample_lnk]: https://github.com/Prime-Holding/rx_bloc/tree/master/examples/booking_app
[favourites_advanced_sample_lnk]: https://github.com/Prime-Holding/rx_bloc/tree/master/examples/favorites_advanced
[counter_bloc_sample_lnk]: https://github.com/Prime-Holding/rx_bloc/tree/master/examples/counter
[division_sample_lnk]: https://github.com/Prime-Holding/rx_bloc/tree/master/examples/division
[intro_to_rx_bloc_pt_1_lnk]: https://medium.com/prime-holding-jsc/introducing-rx-bloc-ecosystem-part-1-3cc5f4fff14e
[intro_to_rx_bloc_pt_2_lnk]: https://medium.com/prime-holding-jsc/introducing-rx-bloc-part-2-faf956f2bd99#c627
[intro_to_rx_bloc_pt_3_lnk]: https://medium.com/prime-holding-jsc/introducing-flutter-rx-bloc-part-3-69d9114da473
[rx_bloc_intellij_plugin_lnk]: https://medium.com/prime-holding-jsc/rxbloc-intellij-plugin-d1d2ddfb7628
[paginated_lists_article_lnk]: https://medium.com/prime-holding-jsc/easy-paginated-lists-in-flutter-b1cfb82188d8
[rx_bloc_cli_article_lnk]: https://medium.com/prime-holding-jsc/bootstrapping-your-flutter-app-with-ease-7efad0aa697a
[reactive_programming_in_flutter_article_lnk]: https://medium.com/prime-holding-jsc/building-complex-apps-in-flutter-with-the-power-of-reactive-programming-54a38fbc0cde
[building_forms_in_flutter_article_lnk]: https://medium.com/prime-holding-jsc/building-forms-in-flutter-454b8d65f48

![CI](https://github.com/Prime-Holding/rx_bloc/workflows/CI/badge.svg) ![style](https://img.shields.io/badge/style-effective_dart-40c4ff.svg) ![license](https://img.shields.io/badge/license-MIT-purple.svg)

Code generator for [rx_bloc](https://pub.dev/packages/rx_bloc "rx_bloc") that makes your BloC zero-boilerplate.

#### How this package can help you.
Often to make your code-base consistent you need to stick to some conventions, which sometimes leads to boilerplate.

> In computer programming, boilerplate is the term used to describe sections of code that have to be included in many places with little or no alteration. It is more often used when referring to languages that are considered verbose, i.e. the programmer must write a lot of code to do minimal jobs.

Apparently, [rx_bloc](https://pub.dev/packages/rx_bloc "rx_bloc") is not an exception. As creating new BloC you might need to write some repetitive code to keep BloC's API consistent. This package benefits of possibility to create custom annotations as generates all needed boilerplate code instead of you. Doing so the BloC itself becomes zero-boilerplate as the rest is handled by the generator.

#### Available annotations

* @RxBloc()
* @RxBlocIgnoreState()
* @RxBlocEvent()

## @RxBloc()
In order to get a clue how actually this annotation would help you let's assume you need to show to the user news feed as have the following BloC:

```dart
abstract class NewsBlocEvents {
  /// Fetch news
  void fetch();
}

abstract class NewsBlocStates {
  /// Presentable news
  Stream<List<News>> get news;
}

class NewsBloc extends RxBlocBase {
  NewsRepository _newsRepository;

  /// Inject all necessary repositories, which the BloC depends on.
  NewsBloc(this._newsRepository);

  /// Map event/s to the news state
  Stream<List<News>> mapToNewsState() => _$fetchEvent 
      .switchMap((_) => _newsRepository.fetch().asResultStream()) // fetch news
      .whereSuccess() // get only success state
      .mapToNews(); // perform some business logic on NewsModel

  ///region inputs - fetch (boilerplate)
  @protected
  final _$fetchEvent = PublishSubject<void>();

  @override
  void fetch() => _$fetchEvent.add(null);
  ///endregion inputs - fetch (boilerplate)
  
 ///region states - news (boilerplate)
  Stream<List<News>> _newsState;

  @override
  Stream<List<News>> get news => _newsState ??= _mapToNewsState();
  ///endregion states - news (boilerplate)
  
  ///region - dispose boilerplate
  @override
  void dispose() {
    _$fetchEvent.close();
    super.dispose();
  }
  ///endregion - dispose boilerplate
}
```

At first look, it might be scary to write so much code just to fetch some news, and that's why this package was created. You need just to add @RxBoc() to ```NewsBloc``` and all mentioned above boilerplate regions will be generated in news_bloc.g.dart with the class name $NewsBloc (the sign $ is an indication that it's generated), so your BloC might look like this:

```dart
abstract class NewsBlocEvents {
  /// Fetch news
  void fetch();
}

abstract class NewsBlocStates {
  /// Presentable news
  Stream<List<News>> get news;
}

@RxBloc()
class NewsBloc extends $NewsBloc {
  NewsRepository _newsRepository;

  /// Inject all necessary repositories, which the BloC depends on.
  NewsBloc(this._newsRepository);

  /// Map event/s to the news state
  @override
  Stream<List<News>> _mapToNewsState() => _$fetchEvent 
      .switchMap((_) => _newsRepository.fetch().asResultStream()) // fetch news
      .whereSuccess() // get only success state
      .mapToNews(); // perform some business logic on NewsModel
}
```

Once you annotate your BloC with @RxBloc() the generator will look for `events` and `states` classes inside the file where the BloC resides. By *convention* they should be named as below but in case you want to name them differently you can specify their names by @RxBloc({this.eventsClassName = "NewsInputs", this.statesClassName = "NewsOutputs"})
 * ${blocName}States
 * ${blocName}Events

##  @RxBlocIgnoreState()
There might be some situations where you would need to define custom state, where all generated boilerplate it would be redundant. For that case just annotate the property of the `states` class with @RxBlocIgnoreState() and the generator won't generate any boilerplate code for it. A good example of this is *errors* or *loading* states as shown [here](https://pub.dev/packages/rx_bloc#usage).

##  @RxBlocEvent()
When working with events, most of the time, they are used to publish changes to the bloc that do not require any initial state. However, there may be some times when you are required to set the state to a custom value or to explicitly annotate the event. All this can be done with the `@RxBlocEvent()` annotation.

@RxBlocEvent annotation has two parameters: the type of the event and the seed value. The type specifies what kind of event will be generated and it can either be a publish event (the default one) or a behaviour event. The seed value, on the other hand, is a value that is valid if used with a behaviour event and represents the initial seed. If the annotation is omitted, the event is treated as a publish event.

Events support multiple parameters and that is no different with the seed value. If the event has one parameter, that value can be seeded as is. But when setting a seed value for an event with more than one parameter, a **private** `event arguments class` which contains all the parameters of that event, is used for that case. The name of the event arguments class is constructed from the event name with the first letter capitalized, by appending `'EventArgs'` at its end.

```dart
abstract class BlocAEvents {
  
  // Event without parameters (no need for setting seed value)
  void noOperation();
  
  // Event with one parameter
  @RxBlocEvent(type:RxBlocEventType.behaviour, seed: 0)
  void add(int number);
  
  // Event with two (or more) parameters
  @RxBlocEvent(type:RxBlocEventType.behaviour, seed: _SubtractEventArgs(0, 0))
  void subtract(int a,int b);
  
}
```

## Error detection
In order to provide a good user experience and easier error detection, this generator handles possible errors that may arise during the development of the bloc. In order to make this possible, there are some conventions to which the developer should stick in order to avoid further errors:

* Events class should define abstract methods only. Any other fields will result in an error.
* When defining a seed value for an event
    - with one parameter : its type should match the one of its argument. 
    - with more than one parameter: the appropriate event arguments class should be used.
* States class should define its members using the `get` keyword.
* States class members should **not** have body definitions.

## Migration notes
* Version >=2.0.0 introduces a change into generating the constructor parameters of the event arguments class.
```dart
 // <2.0.0 the event argument class constructor parameters are always named.
  @RxBlocEvent(type:RxBlocEventType.behaviour, seed: _SubtractEventArgs(a:0, b:0))
  void subtract(int a, int b);
 // =>2.0.0 the event argument class constructor parameters are the same how they are defined for the event method.
   @RxBlocEvent(type:RxBlocEventType.behaviour, seed: _SubtractEventArgs(0, 0))
  void subtract(int a, int b);
  ```

## FAQ
### How I can make the generator working for me ?
* First, add ``rx_bloc_generator`` and ``build_runner`` to the ``dev_dependencies`` in your project.
* Then create your BloC following the mentioned above **Conventions**
* From the root of your project just execute:
  * ``flutter packages pub run build_runner build`` if want to run the generator once.
  * ``flutter packages pub run build_runner watch`` if want to the generator to listen for your changes and to generate boilerplate code on the fly.

### Where I can see more comprehensive examples?
Just open the [example](/example "example") directory of the package or look at the example directory of [flutter_rx_bloc](https://pub.dev/packages/flutter_rx_bloc "flutter_rx_bloc").

### Problems with the generation? 
Make sure you always save your files before running the generator, if that doesn't work you can always try to clean and rebuild.

``flutter packages pub run build_runner clean``

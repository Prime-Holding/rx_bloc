
Code generator for [rx_bloc](https://github.com/Prime-Holding/RxBloc "rx_bloc") that makes your BlocS zero-boilerplate.

#### How this package can help you.
Often to make your code-base consistent you need to stick to some conventions, which sometimes leads to boilerplate.

> In computer programming, boilerplate is the term used to describe sections of code that have to be included in many places with little or no alteration. It is more often used when referring to languages that are considered verbose, i.e. the programmer must write a lot of code to do minimal jobs.

Apparently [rx_bloc](https://github.com/Prime-Holding/RxBloc "rx_bloc") is not an exception. As creating new BloCs you might need to write some repetitive code to keep BloCs API consistent. This package benefits of possibility to create custom annotations as generates all needed boilerplate code instead of you. Doing so the BloC itself becomes zero-boilerplate as the rest is handled by the generator.

#### Avaialbe annotations

* @RxBloc()
* @RxBlocIgnoreState()
* @RxBlocEvent() TODO

## @RxBloc()
In order to get a clue how actually this annotation would help you let's assume we need to show to the user news feed as have the following BloC:

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

  /// Inject all necessary repositories, which the the block depends on.
  NewsBloc(this._newsRepository);

  /// Map event/s to the news state
  Stream<List<News>> mapToNewsState() => $fetchEvent 
      .switchMap((_) => _newsRepository.fetch().asResultStream()) // fetch news
      .whereSuccess() // get only success state
      .mapToNews(); // perform some business logic on NewsModel

  ///region inputs - fetch (boilerplate)
  @protected
  final $fetchEvent = PublishSubject<void>();

  @override
  void fetch() => $fetchEvent.add(null);
  ///endregion inputs - fetch (boilerplate)
  
 ///region states - news (boilerplate)
  Stream<List<News>> _newsState;

  @override
  Stream<List<News>> get news => _newsState ??= mapToNewsState();
  ///endregion states - news (boilerplate)
  
  ///region - dispose boilerplate
  @override
  void dispose() {
    $fetchEvent.close();
    super.dispose();
  }
  ///endregion - dispose boilerplate
}
```

At first look it might be scary to write so much code just to fetch some news, and that's why this package was created. You need just to add @RxBoc() to ```NewsBloc``` and all mentioned above boilerplate regions will be generated in news.g.dart with the class name $NewsBloc (the sign $ is an indication that it's generated), so your block might look like this:

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

  /// Inject all necessary repositories, which the the block depends on.
  NewsBloc(this._newsRepository);

  /// Map event/s to the news state
  @override
  Stream<List<News>> mapToNewsState() => $fetchEvent 
      .switchMap((_) => _newsRepository.fetch().asResultStream()) // fetch news
      .whereSuccess() // get only success state
      .mapToNews(); // perform some business logic on NewsModel
}
```
import 'package:example/model/news_model.dart';
import 'package:example/repository/news_repository.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'news_bloc.rxb.g.dart';

class News {}

abstract class NewsBlocEvents {
  /// Fetch news
  void fetch();
}

abstract class NewsBlocStates {
  /// Presentable news
  Stream<List<News>> get news;

  /// Loading state caused by any registered request
  @RxBlocIgnoreState()
  Stream<bool> get isLoading;

  /// Presentable error messages
  @RxBlocIgnoreState()
  Stream<String> get errors;
}

@RxBloc()
class NewsBloc extends $NewsBloc {
  NewsRepository _newsRepository;

  /// Inject all necessary repositories, which the the block depends on.
  NewsBloc(this._newsRepository);

  /// Map event/s to the news state
  @override
  Stream<List<News>> _mapToNewsState() => _$fetchEvent //auto generated subject
      .switchMap((_) => _newsRepository.fetch().asResultStream()) // fetch news
      .setResultStateHandler(this) // set handlers for loading/error states
      .whereSuccess() // get only success state
      .mapToNews(); // perform some business logic on NewsModel

  /// Presentable error messages
  @override
  Stream<String> get errors => errorState.map(
        (exception) => exception.message,
      );

  /// Loading state caused by any registered request
  @override
  Stream<bool> get isLoading => loadingState;
}

extension _ExceptionMessage on Exception {
  /// Extracted message from the exception
  String get message => this.toString();
}

extension _Mapper on Stream<List<NewsModel>> {
  /// Apply some business logic on NewsModel and convert it to News.
  Stream<List<News>> mapToNews() =>
      map((newsList) => newsList.map((news) => News()));
}

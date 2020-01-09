import 'package:example/model/news_model.dart';

class NewsRepository {
  Future<List<NewsModel>> fetch() =>
      Future.delayed(Duration(seconds: 2), () => [NewsModel()]);
}

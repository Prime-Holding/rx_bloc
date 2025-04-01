import '../data_sources/local/app_links_data_source.dart';

class AppLinksRepository {
  const AppLinksRepository(this._dataSource);

  final AppLinksDataSource _dataSource;

  Future<Uri?> getInitialLink() => _dataSource.getInitialLink();

  Stream<Uri> get uriLinkStream => _dataSource.uriLinkStream;
}

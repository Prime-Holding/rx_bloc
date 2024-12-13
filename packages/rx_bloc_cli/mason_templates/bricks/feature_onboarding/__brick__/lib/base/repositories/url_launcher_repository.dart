{{> licence.dart }}

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/local/url_launcher_local_data_source.dart';

class UrlLauncherRepository {
  UrlLauncherRepository(
    this._errorMapper,
    this._dataSource,
  );

  final ErrorMapper _errorMapper;
  final UrlLauncherLocalDataSource _dataSource;

  /// Opens a given [uri] in the default browser or application.
  /// If [isExternalApplicationMode] is true, it will be forced to open in an
  /// external application.
  Future<void> openUri(String url, {bool isExternalApplicationMode = false}) =>
      _errorMapper.execute(
        () => _dataSource.openUri(
          url,
          isExternalApplicationMode,
        ),
      );
}

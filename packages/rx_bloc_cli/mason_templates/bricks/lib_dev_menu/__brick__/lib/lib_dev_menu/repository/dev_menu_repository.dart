import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../data_source/dev_menu_data_source.dart';

class DevMenuRepository {
  DevMenuRepository(
    this._errorMapper,
    this._dataSource,
  );

  final ErrorMapper _errorMapper;
  final DevMenuDataSource _dataSource;

  Future<void> saveProxy(String proxy) =>
      _errorMapper.execute(() => _dataSource.saveProxy(proxy));

  Future<String?> getProxy() =>
      _errorMapper.execute(() => _dataSource.getProxy());
}

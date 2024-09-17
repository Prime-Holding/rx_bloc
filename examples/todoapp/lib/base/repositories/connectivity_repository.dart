import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/local/connectivity_data_source.dart';

class ConnectivityRepository {
  final ConnectivityDataSource _connectivityDataSource;
  final ErrorMapper _errorMapper;

  ConnectivityRepository(this._connectivityDataSource, this._errorMapper);

  Stream<bool> connected() =>
      _errorMapper.executeStream(_connectivityDataSource.connected());
}

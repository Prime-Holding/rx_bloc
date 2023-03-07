{{> licence.dart }}

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/permissions_remote_data_source.dart';

class PermissionsRepository {
  PermissionsRepository(this._errorMapper, this._permissionsRemoteDataSource);

  final ErrorMapper _errorMapper;
  final PermissionsRemoteDataSource _permissionsRemoteDataSource;

  /// Returns a map of the permissions loaded from the remote data source.
  Future<Map<String, bool>> getPermissions() =>
      _errorMapper.execute(() => _permissionsRemoteDataSource.getPermissions());
}

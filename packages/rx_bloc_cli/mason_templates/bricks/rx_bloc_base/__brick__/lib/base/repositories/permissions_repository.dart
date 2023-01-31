{{> licence.dart }}

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/permissions_remote_data_source.dart';
import '../models/permission_list_model.dart';

class PermissionsRepository {
  PermissionsRepository(this._errorMapper, this._permissionsRemoteDataSource);

  final ErrorMapper _errorMapper;
  final PermissionsRemoteDataSource _permissionsRemoteDataSource;

  Future<PermissionListModel> getPermissions() =>
      _errorMapper.execute(() => _permissionsRemoteDataSource.getPermissions());
}

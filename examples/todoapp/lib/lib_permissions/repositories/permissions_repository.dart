// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../base/utils/no_connection_handle_mixin.dart';
import '../data_sources/local/permissions_local_data_source.dart';
import '../data_sources/remote/permissions_remote_data_source.dart';

class PermissionsRepository with NoConnectionHandlerMixin {
  PermissionsRepository(
    this._errorMapper,
    this._permissionsRemoteDataSource,
    this._permissionsLocalDataSource,
  );

  final ErrorMapper _errorMapper;
  final PermissionsRemoteDataSource _permissionsRemoteDataSource;
  final PermissionsLocalDataSource _permissionsLocalDataSource;
  static const String _permissionsKey = 'permissions';

  // Returns a map of the permissions loaded from the remote data source.
  Future<Map<String, bool>> getPermissions() => _errorMapper.execute(() async {
        final permissions = await _permissionsRemoteDataSource.getPermissions();

        _permissionsLocalDataSource.addPermisions(_permissionsKey, permissions);
        return permissions;
      }).onError((error, stackTrace) => handleError(
            error,
            _permissionsLocalDataSource.getPermissions(_permissionsKey),
          ));
}

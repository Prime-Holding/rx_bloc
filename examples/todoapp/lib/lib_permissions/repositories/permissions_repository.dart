// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:realm/realm.dart';

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../base/utils/no_connection_handle_mixin.dart';
import '../data_sources/local/permissions_local_data_source.dart';
import '../data_sources/remote/permissions_remote_data_source.dart';
import '../models/permission_map_model.dart';
import '../models/permission_model.dart';

class PermissionsRepository with NoConnectionHandlerMixin {
  PermissionsRepository(
    this._errorMapper,
    this._permissionsRemoteDataSource,
    this._permissionsLocalDataSource,
  );

  final ErrorMapper _errorMapper;
  final PermissionsRemoteDataSource _permissionsRemoteDataSource;
  final PermissionsLocalDataSource _permissionsLocalDataSource;

  // Returns a map of the permissions loaded from the remote data source.
  Future<Map<String, bool>> getPermissions() => _errorMapper.execute(() async {
        final permissions = await _permissionsRemoteDataSource.getPermissions();
        final keyValuePairs = permissions.entries
            .map((entry) => PermissionMap(entry.key, entry.value))
            .toList();
        _permissionsLocalDataSource.savePermissions(
          PermissionModel(Uuid.v4().toString(), permissions: keyValuePairs),
        );
        return permissions;
      }).onError((error, stackTrace) => handleError(
            error,
            _permissionsLocalDataSource.getPermissions(),
          ));
}

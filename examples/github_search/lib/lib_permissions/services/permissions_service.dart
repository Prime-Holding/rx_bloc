// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../base/models/errors/error_model.dart';
import '../repositories/permissions_repository.dart';

class PermissionsService {
  PermissionsService(this._permissionsRepository);

  final PermissionsRepository _permissionsRepository;
  Map<String, bool> _permissionList = {};

  /// Checks whether the user has permission to a particular [key].
  ///
  /// Throws an [AccessDeniedErrorModel] if the user don't have permission.
  Future<void> checkPermission(String key) async {
    if (await hasPermission(key)) {
      return;
    }

    throw AccessDeniedErrorModel();
  }

  /// Checks whether the user has permission to a particular [key].
  ///
  /// If [graceful] is `true`, the function will return `true`,
  /// if the permission list cannot be fetched from the remote data source.
  ///
  /// In case the give [key] is not presented in the fetched permission list,
  /// the function will return `true`
  Future<bool> hasPermission(String key, {graceful = false}) async {
    try {
      final permissions = await getPermissions();
      return (permissions.containsKey(key) ? permissions[key]! : true);
    } catch (_) {
      if (graceful == false) {
        rethrow;
      }

      return true;
    }
  }

  /// Checks whether the user has permission to a particular [key].
  bool hasPermissionSync(String key) {
    return (_permissionList.containsKey(key) ? _permissionList[key]! : true);
  }

  /// Returns a map of the permissions
  ///
  /// If [force] is `true`, the permission list is fetched from the remote data
  /// source, otherwise it will try to return it from the cache if the cache is
  /// not empty.
  Future<Map<String, bool>> getPermissions({bool force = false}) async {
    if (_permissionList.isEmpty || force) {
      _permissionList = await _permissionsRepository.getPermissions();
    }

    return _permissionList;
  }

  /// It loads the permissions list from the remote data source
  /// and it renews the cache.
  Future<void> load() async {
    await getPermissions(force: true);
  }
}

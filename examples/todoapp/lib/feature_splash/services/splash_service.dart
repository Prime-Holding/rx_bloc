// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../base/app/initialization/realm_instance.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../../lib_translations/services/translations_service.dart';

class SplashService {
  SplashService(
    PermissionsService permissionsService,
    TranslationsService translationsService,
    RealmInstance realmInstance,
  )   : _permissionsService = permissionsService,
        _translationsService = translationsService,
        _realmInstance = realmInstance;

  final PermissionsService _permissionsService;
  final TranslationsService _translationsService;
  final RealmInstance _realmInstance;

  bool _appInitialized = false;

  Future<void> initializeApp() async {
    await _realmInstance.initializeRealm();
    await Future.wait(_nomenclatures);

    _appInitialized = true;
  }

  List<Future<void>> get _nomenclatures => [
        _permissionsService.load(),
        _translationsService.load(),
      ];

  bool get isAppInitialized => _appInitialized;
}

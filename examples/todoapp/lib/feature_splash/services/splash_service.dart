// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../lib_permissions/services/permissions_service.dart';
import '../../lib_realm/services/realm_service.dart';
import '../../lib_translations/services/translations_service.dart';

class SplashService {
  SplashService(
    PermissionsService permissionsService,
    TranslationsService translationsService,
    RealmService realmService,
  )   : _permissionsService = permissionsService,
        _translationsService = translationsService,
        _realmService = realmService;

  final PermissionsService _permissionsService;
  final TranslationsService _translationsService;
  final RealmService _realmService;

  bool _appInitialized = false;

  Future<void> initializeApp() async {
    await Future.wait(_nomenclatures);

    _appInitialized = true;
  }

  List<Future<void>> get _nomenclatures => [
        _realmService.initializeRealm(),
        _permissionsService.load(),
        _translationsService.load(),
      ];

  bool get isAppInitialized => _appInitialized;
}

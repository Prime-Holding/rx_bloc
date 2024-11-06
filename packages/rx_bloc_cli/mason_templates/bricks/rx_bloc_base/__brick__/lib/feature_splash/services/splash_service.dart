{{> licence.dart }}

import '../../lib_permissions/services/permissions_service.dart';{{#enable_remote_translations}}
import '../../lib_translations/services/translations_service.dart';{{/enable_remote_translations}}

class SplashService {
  SplashService(
    PermissionsService permissionsService,{{#enable_remote_translations}}
    TranslationsService translationsService,{{/enable_remote_translations}}
  )   : _permissionsService = permissionsService{{#enable_remote_translations}},
        _translationsService = translationsService{{/enable_remote_translations}};

  final PermissionsService _permissionsService;{{#enable_remote_translations}}
  final TranslationsService _translationsService;{{/enable_remote_translations}}

  bool _appInitialized = false;

  Future<void> initializeApp() async {
    await Future.wait(_nomenclatures);

    _appInitialized = true;
  }

  List<Future<void>> get _nomenclatures => [
        _permissionsService.load(),{{#enable_remote_translations}}
        _translationsService.load(),{{/enable_remote_translations}}
      ];

  bool get isAppInitialized => _appInitialized;
}

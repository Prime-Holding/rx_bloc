{{> licence.dart }}

import '../../lib_permissions/services/permissions_service.dart';
import '../../lib_translations/services/translations_service.dart';

class SplashService {
  SplashService(
    PermissionsService permissionsService,
    TranslationsService translationsService,
  )   : _permissionsService = permissionsService,
        _translationsService = translationsService;

  final PermissionsService _permissionsService;
  final TranslationsService _translationsService;

  bool _appInitialized = false;

  Future<void> initializeApp() async {
    await Future.wait(_nomenclatures);

    _appInitialized = true;
  }

  List<Future<void>> get _nomenclatures => [
        _permissionsService.load(),
        _translationsService.load(),
      ];

  bool get isAppInitialized => _appInitialized;
}

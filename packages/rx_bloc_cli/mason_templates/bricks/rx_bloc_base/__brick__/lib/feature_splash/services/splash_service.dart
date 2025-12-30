{{> licence.dart }}

import 'dart:async';

import '../../lib_permissions/services/permissions_service.dart';

class SplashService {
  SplashService(PermissionsService permissionsService)
  : _permissionsService = permissionsService;

  final PermissionsService _permissionsService;

  Future<void> initializeApp() async {
    await Future.wait(_nomenclatures);

    _appInitialized.complete();
  }

  List<Future<void>> get _nomenclatures => [
        _permissionsService.load(),
      ];

  final Completer<void> _appInitialized = Completer<void>();

  Future<void> get appInitialized => _appInitialized.future;
}

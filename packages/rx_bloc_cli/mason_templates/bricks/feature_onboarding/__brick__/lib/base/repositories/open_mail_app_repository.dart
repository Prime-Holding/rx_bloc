{{> licence.dart }}

import 'dart:io';
import 'url_launcher_repository.dart';

class OpenMailAppRepository {
  OpenMailAppRepository(this._urlLauncherRepository);

  final UrlLauncherRepository _urlLauncherRepository;

  /// Opens the mail client.
  ///
  /// Currently opens the "Send e-mail" page in the client, should be replaced
  /// with a dialog of available mail clients to choose from
  Future<void> openMailApp() => _urlLauncherRepository.openUri(
        _uri,
        isExternalApplicationMode: true,
      );

  String get _uri {
    if (Platform.isIOS) {
      return 'message://';
    }

    return 'mailto:';
  }
}

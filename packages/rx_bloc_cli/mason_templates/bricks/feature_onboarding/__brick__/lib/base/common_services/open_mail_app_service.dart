{{> licence.dart }}

import '../repositories/open_mail_app_repository.dart';

class OpenMailAppService {
  final OpenMailAppRepository _openMailAppRepository;

  OpenMailAppService(this._openMailAppRepository);

  /// Opens the mail client.
  ///
  /// Currently opens the "Send e-mail" page in the client, should be replaced
  /// with a dialog of available mail clients to choose from
  Future<void> openMailApp() => _openMailAppRepository.openMailApp();
}

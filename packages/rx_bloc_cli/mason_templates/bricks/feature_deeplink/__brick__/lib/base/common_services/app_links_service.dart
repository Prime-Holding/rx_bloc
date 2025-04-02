{{> licence.dart }}

import '../repositories/app_links_repository.dart';

class AppLinksService {
  final AppLinksRepository _repository;

  AppLinksService(this._repository);

  /// Gets the initial / first link
  ///
  /// returns [Uri] if the app is cold-started from a deeplink or [null]
  Future<Uri?> getInitialLink() => _repository.getInitialLink();

  /// Stream of deeplinks
  ///
  /// returns Streamo of [Uri] used for monitoring deeplinks
  Stream<Uri> get uriLinkStream => _repository.uriLinkStream;
}

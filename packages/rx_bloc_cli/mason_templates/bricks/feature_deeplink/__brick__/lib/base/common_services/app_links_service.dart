{{> licence.dart }}

import 'dart:async';
import '../repositories/app_links_repository.dart';

class AppLinksService {
  final AppLinksRepository _repository;
  StreamSubscription<Uri>? _uriLinkSubscription;

  AppLinksService(this._repository);

  /// Gets the initial / first link
  ///
  /// returns [Uri] if the app is cold-started from a deeplink or [null]
  Future<Uri?> getInitialLink() => _repository.getInitialLink();

  /// Stream of deeplinks
  ///
  /// returns Streamo of [Uri] used for monitoring deeplinks
  Stream<Uri> get uriLinkStream => _repository.uriLinkStream;

  /// Subscribe to uri link stream with a callback
  void subscribeToUriLinks(void Function(Uri) callback) {
    _uriLinkSubscription?.cancel();
    _uriLinkSubscription = uriLinkStream.listen(callback);
  }

  /// Dispose of the service and its subscriptions
  void dispose() {
    _uriLinkSubscription?.cancel();
  }
}

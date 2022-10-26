{{> licence.dart }}

import '../models/push_notification_token.dart';

class PushTokenRepository {
  final Map<String, PushNotificationToken> _pushTokens = {};

  void addPushToken(String token) {
    final newToken = PushNotificationToken(token);
    _pushTokens[token] = newToken;
  }

  bool removePushToken(String token) {
    final existingToken = _pushTokens[token];
    if (existingToken == null) return false;
    _pushTokens.remove(token);
    return true;
  }

  bool hasToken(String token) => _pushTokens.containsKey(token);

  List<PushNotificationToken> get tokens => _pushTokens.values.toList();
}

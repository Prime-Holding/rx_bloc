import '../models/push_notification_token.dart';

class PushTokenRepository {
  final Map<String, PushNotificationToken> _pushTokens = {};

  void addPushToken(String token) {
    final _token = PushNotificationToken(token);

    _pushTokens[token] = _token;
  }

  bool removePushToken(String token) {
    final _token = _pushTokens[token];
    if (_token == null) return false;
    _pushTokens.remove(token);
    return true;
  }

  bool hasToken(String token) => _pushTokens.containsKey(token);

  List<PushNotificationToken> get tokens => _pushTokens.values.toList();
}

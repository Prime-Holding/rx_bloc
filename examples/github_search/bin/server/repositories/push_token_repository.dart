import '../models/push_notification_token.dart';

class PushTokenRepository {
  final Map<String, PushNotificationToken> _pushTokens = {};

  void addPushToken(String token) {
    final token0 = PushNotificationToken(token);

    _pushTokens[token] = token0;
  }

  bool removePushToken(String token) {
    final token0 = _pushTokens[token];
    if (token0 == null) return false;
    _pushTokens.remove(token);
    return true;
  }

  bool hasToken(String token) => _pushTokens.containsKey(token);

  List<PushNotificationToken> get tokens => _pushTokens.values.toList();
}

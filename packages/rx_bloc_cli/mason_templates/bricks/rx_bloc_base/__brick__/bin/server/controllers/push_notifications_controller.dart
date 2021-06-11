import 'package:shelf/shelf.dart';

import '../utils/api_controller.dart';

class PushNotificationsController extends ApiController {
  final _pushTokens = <String>[];

  @override
  void registerRequests() {
    addRequest(RequestType.POST, '/api/user/push-notification-subscriptions',
        registerPushHandler);
    addRequest(RequestType.DELETE, '/api/user/push-notification-subscriptions',
        unregisterPushHandler);
  }

  Response registerPushHandler(Request request) {
    print('Authenticating');
    _registerPushToken('123');
    return responseBuilder.buildOK();
  }

  Response unregisterPushHandler(Request request) {
    _unregisterPushToken('123');
    return responseBuilder.buildOK();
  }

  void _registerPushToken(String pushToken) {
    if (!_pushTokens.contains(pushToken)) {
      _pushTokens.add(pushToken);
    }
  }

  void _unregisterPushToken(String pushToken) {
    if (_pushTokens.contains(pushToken)) {
      _pushTokens.remove(pushToken);
    }
  }
}

import 'package:shelf/shelf.dart';

import '../repositories/push_token_repository.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';
import 'authentication_controller.dart';

// ignore_for_file: cascade_invocations

class PushNotificationsController extends ApiController {
  final _pushTokens = PushTokenRepository();

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.POST,
      '/api/user/push-notification-subscriptions',
      _registerPushHandler,
    );
    router.addRequest(
      RequestType.DELETE,
      '/api/user/push-notification-subscriptions',
      _unregisterPushHandler,
    );
  }

  Response _registerPushHandler(Request request) {
    controllers
        .getController<AuthenticationController>()
        ?.isAuthenticated(request);

    final pushToken = request.url.queryParameters['pushToken'];
    if (pushToken == null || pushToken.isEmpty) {
      throw BadRequestException('Push token can not be empty.');
    }

    _pushTokens.addPushToken(pushToken);

    return responseBuilder.buildOK();
  }

  Response _unregisterPushHandler(Request request) {
    controllers
        .getController<AuthenticationController>()
        ?.isAuthenticated(request);

    final pushToken = request.url.queryParameters['pushToken'];
    if (pushToken == null || pushToken.isEmpty) {
      throw BadRequestException('Push token can not be empty.');
    }

    _pushTokens.removePushToken(pushToken);

    return responseBuilder.buildOK();
  }
}

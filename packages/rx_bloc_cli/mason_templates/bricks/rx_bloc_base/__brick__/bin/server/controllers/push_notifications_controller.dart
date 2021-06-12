import 'package:shelf/shelf.dart';

import '../repositories/push_token_repository.dart';
import '../utils/api_controller.dart';
import 'authentication_controller.dart';

// ignore_for_file: cascade_invocations

class PushNotificationsController extends ApiController {
  final _pushTokens = PushTokenRepository();

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/user/push-notification-subscriptions',
      _getPushTokensHandler,
    );
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

  Response _getPushTokensHandler(Request request) {
    controllers
        .getController<AuthenticationController>()
        ?.isAuthenticated(request);

    /// Return all push tokens for current user

    return responseBuilder.buildOK();
  }

  Response _registerPushHandler(Request request) {
    controllers
        .getController<AuthenticationController>()
        ?.isAuthenticated(request);

    /// Add push token to query url when making request
    _pushTokens.addPushToken('12345');

    return responseBuilder.buildOK();
  }

  Response _unregisterPushHandler(Request request) {
    controllers
        .getController<AuthenticationController>()
        ?.isAuthenticated(request);

    /// Remove the token based on the user data
    _pushTokens.removePushToken('12345');

    return responseBuilder.buildOK();
  }
}

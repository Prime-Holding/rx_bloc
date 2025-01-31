{{> licence.dart }}

import 'package:shelf/shelf.dart';

import '../repositories/push_token_repository.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

// ignore_for_file: cascade_invocations
// ignore_for_file: lines_longer_than_80_chars

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

  Future<Response> _registerPushHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final pushToken = params['pushToken'];

    throwIfEmpty(
      pushToken,
      BadRequestException('Push token can not be empty.'),
    );

    _pushTokens.addPushToken(pushToken);

    return responseBuilder.buildOK();
  }

  Future<Response> _unregisterPushHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final pushToken = params['pushToken'];

    throwIfEmpty(
      pushToken,
      BadRequestException('Push token can not be empty.'),
    );

    _pushTokens.removePushToken(pushToken);

    return responseBuilder.buildOK();
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import '../config.dart';
import '../repositories/push_token_repository.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';
import 'authentication_controller.dart';

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
    router.addRequest(
      RequestType.POST,
      '/api/send-push-message',
      _broadcastPushHandler,
    );
  }

  Future<Response> _registerPushHandler(Request request) async {
    controllers
        .getController<AuthenticationController>()
        ?.isAuthenticated(request);

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
    controllers
        .getController<AuthenticationController>()
        ?.isAuthenticated(request);

    final params = await request.bodyFromFormData();
    final pushToken = params['pushToken'];

    throwIfEmpty(
      pushToken,
      BadRequestException('Push token can not be empty.'),
    );

    _pushTokens.removePushToken(pushToken);

    return responseBuilder.buildOK();
  }

  Future<Response> _broadcastPushHandler(Request request) async {
    controllers
        .getController<AuthenticationController>()
        ?.isAuthenticated(request);

    final params = await request.bodyFromFormData();
    final title = params['title'];
    final message = params['message'];

    final _delayParam = params['delay'];
    final delay = _delayParam != null && (_delayParam is int)
        ? _delayParam
        : int.parse(_delayParam ?? '0');

    throwIfEmpty(
      message,
      BadRequestException('Push message can not be empty.'),
    );

    Future.delayed(Duration(seconds: delay),
        () async => _sendMessage(title: title, message: message));

    return responseBuilder.buildOK();
  }

  Future<http.Response> _sendMessage({
    String? title,
    String message = '',
    Map<String, Object?>? data,
    bool logMessage = true,
  }) async {
    final res = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=$firebasePushServerKey',
      },
      body: jsonEncode({
        'registration_ids': _pushTokens.tokens.map((e) => e.token).toList(),
        // "to" : single_push_token, // Use this for only one recipient
        'notification': {
          'title': title ?? 'Hello world!',
          'body': message,
        },
        'data': data ?? {},
      }),
    );
    if (logMessage) {
      print(
          'Notification sent: StatusCode: ${res.statusCode}  ResponseBody: ${res.body}');
    }
    return res;
  }
}

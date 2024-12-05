{{> licence.dart }}

import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import '../config.dart';
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
    router.addRequest(
      RequestType.POST,
      '/api/send-push-message',
      _broadcastPushHandler,
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

  Future<Response> _broadcastPushHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final title = params['title'];
    final message = params['message'];
    final data = params['data'];
    final pushToken = params['pushToken'];

    final delayParam = params['delay'];
    final delay = delayParam != null && (delayParam is int)
        ? delayParam
        : int.parse(delayParam ?? '0');

    throwIfEmpty(
      message,
      BadRequestException('Push message can not be empty.'),
    );
    if (!(_pushTokens.tokens.any((element) => element.token == pushToken))) {
      throw NotFoundException('Notifications disabled by the user');
    }
    final accessToken = await _getAccessToken();
    for (var token in _pushTokens.tokens) {
      Future.delayed(
        Duration(seconds: delay),
        () async => _sendMessage(
          accessToken: accessToken,
          title: title,
          message: message,
          data: data,
          pushToken: token.token,
        ),
      );
    }

    return responseBuilder.buildOK();
  }

  Future<void> _sendMessage({
    required String accessToken,
    String? title,
    String message = '',
    Map<String, Object?>? data,
    bool logMessage = true,
    String? pushToken,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': pushToken,
            // "topic": topic, // Use this for a topic
            'notification': {
              'title': title ?? 'Hello world!',
              'body': message,
            },
            'data': data ?? {},
          },
        }),
      );
      if (logMessage) {
        print(
            'Notification sent: StatusCode: ${res.statusCode}  ResponseBody: ${res.body}');
      }
    } catch (e) {
      throw ServerException('Error sending push notification');
    }
  }

  Future<String> _getAccessToken() async {
    try {
      //the scope url for the firebase messaging
      String firebaseMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      //get the service account from the environment variables or from the .env file where it has been stored.
      //it is advised not to hardcode the service account details in the code
      Map<String, dynamic> serviceAccount =
          json.decode(const String.fromEnvironment('FIREBASE_SERVICE_ACCOUNT'));
      final client = await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson(serviceAccount),
          [firebaseMessagingScope]);

      final accessToken = client.credentials.accessToken.data;
      return accessToken;
    } catch (_) {
      //handle your error here
      throw Exception('Error getting access token');
    }
  }
}

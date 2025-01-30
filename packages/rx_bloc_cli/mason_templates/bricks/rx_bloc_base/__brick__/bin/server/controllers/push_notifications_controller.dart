{{> licence.dart }}

import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
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

  Future<String> _getAccessToken() async {
    try {
      //the scope url for the firebase messaging
      String firebaseMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      //get the service account from the json file 
      final serviceAccount =
          json.decode(await File(serviceAccountKeyPath).readAsString());
      final client = await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson(serviceAccount),
          [firebaseMessagingScope]);

      final accessToken = client.credentials.accessToken.data;
      client.close();
      return accessToken;
    } catch (_) {
      //handle your error here
      throw Exception('Error getting access token');
    }
  }
}

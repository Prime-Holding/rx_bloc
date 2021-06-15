// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'send_notifications_bloc.dart';

extension _SendNotificationsBlocExtensions on SendNotificationsBloc {
  // Checks if the user has granted permissions for displaying push messages.
  // If called the very first time, the user is asked to grant permissions.
  Future<bool> _getAuthStatus() async {
    {{#push_notifications}}
    final settings = await FirebaseMessaging.instance.requestPermission();
    return settings.authorizationStatus != AuthorizationStatus.denied; {{/push_notifications}} {{^push_notifications}}
    // TODO: Implement your logic for granting permissions for push messages
    return true;
    {{/push_notifications}}
  }

  // Sends a push message to the remote server
  Future<bool> _sendMessage(_SendMessageEventArgs args) async {
    await _notificationsRepo.sendPushMessage(
        message: args.message, title: args.title, delay: args.delay);
    return true;
  }
}

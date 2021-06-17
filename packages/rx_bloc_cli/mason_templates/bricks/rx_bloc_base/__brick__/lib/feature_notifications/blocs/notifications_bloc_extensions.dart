// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'notifications_bloc.dart';

/// Extensions for the NotificationsBloc
extension _SendNotificationsBlocExtensions on NotificationsBloc {
  // Sends a push message to the remote server
  Future<bool> _sendMessage(_SendMessageEventArgs args) async {
    await _notificationsRepo.sendPushMessage(
        message: args.message, title: args.title, delay: args.delay);
    return true;
  }
}

/// Extensions for Publish Subjects of type _SendMessageEventArgs
extension _PushSubjectMsgArgsExtensions
on PublishSubject<_SendMessageEventArgs> {
  Stream<Result<bool>> _sendMessage(NotificationsBloc bloc) =>
      switchMap((args) => bloc._sendMessage(args).asResultStream());
}

/// Extensions for Publish Subjects of type void
extension _PushSubjectVoidExtensions on PublishSubject<void> {
  Stream<Result<bool>> _requestPermissions(NotificationsBloc bloc) =>
      switchMap((_) => bloc._firebaseMessagingDataSource
          .requestNotificationPermissions()
          .asResultStream());
}

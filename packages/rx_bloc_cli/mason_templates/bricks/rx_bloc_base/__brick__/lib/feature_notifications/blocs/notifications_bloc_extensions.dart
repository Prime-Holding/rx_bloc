// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'notifications_bloc.dart';

/// Extensions for the NotificationsBloc
extension _NotificationsBlocExtensions on NotificationsBloc {}

/// Extensions for Publish Subjects of type _SendMessageEventArgs
extension _PushSubjectMsgArgsExtensions
    on PublishSubject<_SendMessageEventArgs> {
  Stream<Result<bool>> sendMessage(
    PushNotificationRepository repository,
  ) =>
      // Sends a push message to the remote server
      switchMap((args) => repository
          .sendPushMessage(
            message: args.message,
            title: args.title,
            delay: args.delay,
          )
          .asStream()).map((event) => true).asResultStream();
}

/// Extensions for Publish Subjects of type void
extension _PushSubjectVoidExtensions on PublishSubject<void> {
  Stream<Result<bool>> requestPermissions(
    PushNotificationRepository repository,
  ) =>
      switchMap(
        (_) => repository.requestNotificationPermissions().asResultStream(),
      );
}

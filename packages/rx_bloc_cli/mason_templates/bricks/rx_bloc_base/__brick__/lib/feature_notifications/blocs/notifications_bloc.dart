// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/data_sources/domain/firebase/firebase_messaging_data_source.dart';
import '../../base/repositories/push_notification_subscription_repository.dart';

part 'notifications_bloc.rxb.g.dart';
part 'notifications_bloc_extensions.dart';

/// A contract class containing all events of the NotificationsBloC.
abstract class NotificationsBlocEvents {
  /// Requests permissions for displaying push notifications
  void requestNotificationPermissions();

  /// Issues a new push message
  void sendMessage(String message, {String? title, int? delay});
}

/// A contract class containing all states of the NotificationsBloC.
abstract class NotificationsBlocStates {
  /// Are the permissions for displaying push notifications granted
  Stream<bool> get permissionsAuthorized;
}

@RxBloc()
class NotificationsBloc extends $NotificationsBloc {
  NotificationsBloc(this._notificationsRepo, this._firebaseMessagingDataSource);

  final PushNotificationSubscriptionRepository _notificationsRepo;
  final FirebaseMessagingDataSource _firebaseMessagingDataSource;

  @override
  Stream<bool> _mapToPermissionsAuthorizedState() => Rx.merge([
        _$sendMessageEvent.sendMessage(this),
        _$requestNotificationPermissionsEvent.requestPermissions(this),
      ]).setResultStateHandler(this).whereSuccess();
}

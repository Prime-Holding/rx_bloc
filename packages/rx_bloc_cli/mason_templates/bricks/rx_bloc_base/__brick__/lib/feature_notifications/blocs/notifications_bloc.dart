import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

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
  NotificationsBloc(this._notificationsRepo);

  final PushNotificationSubscriptionRepository _notificationsRepo;

  @override
  Stream<bool> _mapToPermissionsAuthorizedState() => Rx.merge([
    _$sendMessageEvent._sendMessage(this),
    _$requestNotificationPermissionsEvent._requestPermissions(this),
  ]).setResultStateHandler(this).whereSuccess();
}

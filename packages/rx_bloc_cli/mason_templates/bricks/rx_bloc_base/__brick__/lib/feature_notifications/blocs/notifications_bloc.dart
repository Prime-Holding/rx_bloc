{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/repositories/push_notification_repository.dart';

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
  NotificationsBloc(PushNotificationRepository notificationsRepo)
      : _notificationsRepo = notificationsRepo;

  final PushNotificationRepository _notificationsRepo;

  @override
  Stream<bool> _mapToPermissionsAuthorizedState() => Rx.merge([
        _$sendMessageEvent.sendMessage(_notificationsRepo),
        _$requestNotificationPermissionsEvent.requestPermissions(
          _notificationsRepo,
        ),
      ]).setResultStateHandler(this).whereSuccess();
}

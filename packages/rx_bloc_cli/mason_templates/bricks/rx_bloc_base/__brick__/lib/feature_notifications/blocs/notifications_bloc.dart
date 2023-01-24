{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../services/notifications_service.dart';

part 'notifications_bloc.rxb.g.dart';

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
  NotificationsBloc(this._service);

  final NotificationService _service;

  @override
  Stream<bool> _mapToPermissionsAuthorizedState() => Rx.merge([
        _$sendMessageEvent.switchMap(
          (args) => _service
              .sendPushMessage(
                message: args.message,
                title: args.title,
                delay: args.delay,
              )
              .then((_) => true)
              .asResultStream(),
        ),
        _$requestNotificationPermissionsEvent.switchMap(
          (_) => _service.requestNotificationPermissions().asResultStream(),
        ),
      ]).setResultStateHandler(this).whereSuccess();
}

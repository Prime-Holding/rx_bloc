{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/models/errors/error_model.dart';
import '../services/notifications_service.dart';

part 'notifications_bloc.rxb.g.dart';

/// A contract class containing all events of the NotificationsBloC.
abstract class NotificationsBlocEvents {
  /// Requests permissions for displaying push notifications
  void requestNotificationPermissions();
}

/// A contract class containing all states of the NotificationsBloC.
abstract class NotificationsBlocStates {
  /// Are the permissions for displaying push notifications granted
  Stream<bool> get permissionsAuthorized;

  /// The push token to which the developers can send notifications
  ConnectableStream<Result<String>> get pushToken;
}

@RxBloc()
class NotificationsBloc extends $NotificationsBloc {
  NotificationsBloc(this._service) {
    pushToken.connect().addTo(_compositeSubscription);
  }

  final NotificationService _service;


  @override
  Stream<bool> _mapToPermissionsAuthorizedState() =>
_$requestNotificationPermissionsEvent
    .switchMap(
(_) => _service.requestNotificationPermissions().asResultStream(),
)
    .setResultStateHandler(this)
    .whereSuccess();

  @override
  ConnectableStream<Result<String>> _mapToPushTokenState() =>
      PublishSubject<String>()
          .startWith('')
          .switchMap((_) => _service.getPushToken().asResultStream())
          .setResultStateHandler(this)
          .mapResult((token) => token ?? (throw NotFoundErrorModel()))
          .publish();
}

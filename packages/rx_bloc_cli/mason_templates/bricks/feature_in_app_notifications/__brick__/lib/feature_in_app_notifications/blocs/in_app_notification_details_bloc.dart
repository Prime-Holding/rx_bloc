import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../models/in_app_notification_model.dart';
import '../services/in_app_notifications_service.dart';

part 'in_app_notification_details_bloc.rxb.g.dart';

/// A contract class containing all events of the InAppNotificationDetailsBloC.
abstract class InAppNotificationDetailsBlocEvents {
  /// Fetches the notification details by the notification id
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void fetchNotification(String id);
}

/// A contract class containing all states of the InAppNotificationDetailsBloC.
abstract class InAppNotificationDetailsBlocStates {
  /// The notification details result stream
  Stream<Result<InAppNotificationModel>> get notification;
}

/// A bloc that fetches the notification details by the notification id
@RxBloc()
class InAppNotificationDetailsBloc extends $InAppNotificationDetailsBloc {
  InAppNotificationDetailsBloc(this._service, {required String notificationId})
      : _notificationId = notificationId;

  final InAppNotificationsService _service;
  final String _notificationId;

  @override
  Stream<Result<InAppNotificationModel>> _mapToNotificationState() =>
      _$fetchNotificationEvent
          .startWith(_notificationId)
          .switchMap((id) => _service.getNotificationById(id).asResultStream())
          .setResultStateHandler(this)
          .shareReplay(maxSize: 1);
}

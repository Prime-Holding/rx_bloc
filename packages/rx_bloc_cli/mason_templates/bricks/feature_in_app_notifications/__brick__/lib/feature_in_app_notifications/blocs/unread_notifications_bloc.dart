import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/models/notification_event_model.dart';
import '../services/in_app_notifications_service.dart';

part 'unread_notifications_bloc.rxb.g.dart';

/// A contract class containing all events of the UnreadNotificationsBloC.
abstract class UnreadNotificationsBlocEvents {
  /// Fetches the count of unread in-app notifications
  void fetchUnreadNotifications();
}

/// A contract class containing all states of the UnreadNotificationsBloC.
abstract class UnreadNotificationsBlocStates {
  /// The count of unread in-app notifications
  Stream<int> get inAppNotificationCount;
}

@RxBloc()
class UnreadNotificationsBloc extends $UnreadNotificationsBloc {
  UnreadNotificationsBloc(
      this._inAppNotificationsService, this._coordinatorBloc);

  final InAppNotificationsService _inAppNotificationsService;
  final CoordinatorBlocType _coordinatorBloc;

  @override
  Stream<int> _mapToInAppNotificationCountState() => Rx.merge([
        _$fetchUnreadNotificationsEvent.startWith(null),
        _coordinatorBloc.states.notificationEvents.where(
          (event) => event.type == NotificationEventType.newNotification,
        ),
      ])
          .switchMap(
            (_) => _inAppNotificationsService
                .getUnreadCount()
                .asResultStream()
                .setResultStateHandler(this)
                .whereSuccess(),
          )
          .startWith(0)
          .publishReplay(maxSize: 1)
          .autoConnect();
}

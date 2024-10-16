{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../models/notification_model.dart';
part 'push_notifications_bloc.rxb.g.dart';

/// A contract class containing all events of the PushNotificationsBloC.
abstract class PushNotificationsBlocEvents {
  /// Event for handling opening push notifications from background
  /// or from in-app
  void tapOnEvent(NotificationModel event);
}

/// A contract class containing all states of the PushNotificationsBloC.
abstract class PushNotificationsBlocStates {}

@RxBloc()
class PushNotificationsBloc extends $PushNotificationsBloc {
  PushNotificationsBloc(this._routerBloc) {
    _onRedirectingNotification.connect().addTo(_compositeSubscription);
  }

  final RouterBlocType _routerBloc;

  late final ConnectableStream<void> _onRedirectingNotification =
      _$tapOnEventEvent.asyncMap<void>((event) {
    switch (event.type) {
      case NotificationModelType.dashboard:
        return _routerBloc.events.go(const DashboardRoute());{{#enable_profile}}
      case NotificationModelType.profile:
        return _routerBloc.events.go(const ProfileRoute());{{/enable_profile}}
      default:
        null;
    }
  }).publish();
}

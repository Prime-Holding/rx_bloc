{{> licence.dart }}

import 'package:go_router/go_router.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

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
  PushNotificationsBloc(this._router) {
    _onRedirectingNotification.connect().addTo(_compositeSubscription);
  }

  final GoRouter _router;

  late final ConnectableStream<void> _onRedirectingNotification =
      _$tapOnEventEvent.asyncMap<void>((event) {
    switch (event.type) {
      case NotificationModelType.dashboard:
        _router.go(const DashboardRoute().routeLocation);{{#enable_profile}}
      case NotificationModelType.profile:
        _router.go(const ProfileRoute().routeLocation);{{/enable_profile}}
      default:
        null;
    }
  }).publish();
}

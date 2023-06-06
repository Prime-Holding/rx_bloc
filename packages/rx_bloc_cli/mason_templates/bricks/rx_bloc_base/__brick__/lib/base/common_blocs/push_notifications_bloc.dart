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
abstract class PushNotificationsBlocStates {
  ///State used for handling routing on push notification recived
  ConnectableStream<void> get onRouting;
}

@RxBloc()
class PushNotificationsBloc extends $PushNotificationsBloc {
  PushNotificationsBloc(this._routerBloc) {
    onRouting.connect().addTo(_compositeSubscription);
  }

  final RouterBlocType _routerBloc;

  @override
  ConnectableStream<void> _mapToOnRoutingState() =>
      _$tapOnEventEvent.asyncMap<void>((event) {
        switch (event.type) {
          case NotificationModelType.dashboard:
            return _routerBloc.events.go(const DashboardRoute());
          case NotificationModelType.profile:
            return _routerBloc.events.go(const ProfileRoute());
          default:
            null;
        }
      }).publish();
}
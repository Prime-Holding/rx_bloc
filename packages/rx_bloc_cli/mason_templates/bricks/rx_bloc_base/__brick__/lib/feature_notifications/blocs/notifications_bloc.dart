{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../services/notifications_service.dart';

part 'notifications_bloc.rxb.g.dart';

/// A contract class containing all events of the NotificationsBloC.
abstract class NotificationsBlocEvents {
  // Fetch notifications provider push token
  void fetchPushToken();
}

/// A contract class containing all states of the NotificationsBloC.
abstract class NotificationsBlocStates {
  /// The push token to which the developers can send notifications
  ConnectableStream<Result<String>> get pushToken;

  /// The error state
  Stream<ErrorModel> get errors;
}

@RxBloc()
class NotificationsBloc extends $NotificationsBloc {
  NotificationsBloc(this._service) {
    pushToken.connect().addTo(_compositeSubscription);
  }

  final NotificationService _service;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  ConnectableStream<Result<String>> _mapToPushTokenState() =>
      _$fetchPushTokenEvent
          .startWith(null)
          .switchMap(
            (_) => _service.getPushToken().asResultStream(),
          )
          .setResultStateHandler(this)
          .publish();
}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../models/in_app_notification_model.dart';
import '../services/in_app_notifications_service.dart';

part 'in_app_notification_details_bloc.rxb.g.dart';

/// A contract class containing all events of the InAppNotificationDetailsBloC.
abstract class InAppNotificationDetailsBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void fetchNotification(String id);
}

/// A contract class containing all states of the InAppNotificationDetailsBloC.
abstract class InAppNotificationDetailsBlocStates {
  Stream<bool> get isLoading;

  Stream<ErrorModel> get errors;

  Stream<Result<InAppNotificationModel>> get notification;
}

@RxBloc()
class InAppNotificationDetailsBloc extends $InAppNotificationDetailsBloc {
  InAppNotificationDetailsBloc(
    this._service, {
    required this.notificationId,
  });

  final InAppNotificationsService _service;
  final String notificationId;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<Result<InAppNotificationModel>> _mapToNotificationState() =>
      _$fetchNotificationEvent.startWith(notificationId)
          .switchMap(
            (id) => _service.getNotificationById(id).asResultStream(),
          )
          .setResultStateHandler(this)
          .shareReplay(maxSize: 1);
}

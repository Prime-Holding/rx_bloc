{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_services/push_notifications_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';

part 'profile_bloc.rxb.g.dart';

/// A contract class containing all events of the ProfileBloC.
abstract class ProfileBlocEvents {
  void toggleNotifications();
}

/// A contract class containing all states of the ProfileBloC.
abstract class ProfileBlocStates {
  /// The state representing the if the notifications are enabled
  ConnectableStream<Result<bool>> get areNotificationsEnabled;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;
}

@RxBloc()
class ProfileBloc extends $ProfileBloc {
  ProfileBloc(this._notificationService) {
    areNotificationsEnabled.connect().addTo(_compositeSubscription);
  }
  final PushNotificationsService _notificationService;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  ConnectableStream<Result<bool>> _mapToAreNotificationsEnabledState() =>
      Rx.merge([
        _$toggleNotificationsEvent.switchMap((_) => _notificationService
            .toggleNotifications()
            .asResultStream()),
        _syncAndCheckNotifications().asResultStream(),
      ]).setResultStateHandler(this).publishReplay(maxSize: 1);

  Future<bool> _syncAndCheckNotifications() async {
    await _notificationService.syncNotificationSettings();
    return await _notificationService.areNotificationsEnabled();
  }
}

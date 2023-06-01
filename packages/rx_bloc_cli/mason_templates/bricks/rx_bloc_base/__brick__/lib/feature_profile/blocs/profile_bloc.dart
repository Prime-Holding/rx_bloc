{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_services/push_notifications_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';

part 'profile_bloc.rxb.g.dart';

/// A contract class containing all events of the ProfileBloC.
abstract class ProfileBlocEvents {

  void setNotifications(bool enabled);

  void requestNotificationPermissions();
}

/// A contract class containing all states of the ProfileBloC.
abstract class ProfileBlocStates {

  Stream<Result<bool>> get areNotificationsEnabled;
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;
}

@RxBloc()
class ProfileBloc extends $ProfileBloc {
  ProfileBloc(this._notificationService);
  final PushNotificationsService _notificationService;

  static const tagNotificationSubscribe = 'tagNotificationSubscribe';
  static const tagNotificationUnsubscribe = 'tagNotificationUnsubscribe';

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<Result<bool>> _mapToAreNotificationsEnabledState() => Rx.merge([
        _notificationService.isSubscribed().asResultStream(),
        _$setNotificationsEvent.switchMap(
          (subscribePushNotifications) {
            if (subscribePushNotifications) {
              return _notificationService
                  .subscribe()
                  .then((_) => true)
                  .asResultStream(tag: tagNotificationSubscribe);
            }

            return _notificationService
                .unsubscribe()
                .then((_) => false)
                .asResultStream(tag: tagNotificationUnsubscribe);
          },
        ),
      ]).setResultStateHandler(this).shareReplay(maxSize: 1);
}

{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_services/push_notifications_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart'; {{#enable_pin_code}}
import '../services/biometrics_auth_service.dart'; {{/enable_pin_code}}

part 'profile_bloc.rxb.g.dart';

/// A contract class containing all events of the ProfileBloC.
abstract class ProfileBlocEvents {
  void setNotifications(bool enabled);

  void loadNotificationsSettings();
}

/// A contract class containing all states of the ProfileBloC.
abstract class ProfileBlocStates {
  Stream<Result<bool>> get areNotificationsEnabled;

  ConnectableStream<Result<bool>> get syncNotificationsStatus;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  {{#enable_pin_code}}
  /// The state responsible for showing the biometrics switch button if the
  /// device has biometrics support enabled.
  Stream<bool> get isBiometricsAuthEnabled;
  {{/enable_pin_code}}
}

@RxBloc()
class ProfileBloc extends $ProfileBloc {
  ProfileBloc(
    this._notificationService,  {{#enable_pin_code}}
    this._biometricsService,  {{/enable_pin_code}}
    ) {
    syncNotificationsStatus.connect().addTo(_compositeSubscription);
  }
  final PushNotificationsService _notificationService; {{#enable_pin_code}}
  final BiometricsAuthService _biometricsService; {{/enable_pin_code}}

  static const tagNotificationSubscribe = 'tagNotificationSubscribe';
  static const tagNotificationUnsubscribe = 'tagNotificationUnsubscribe';

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  ConnectableStream<Result<bool>> _mapToSyncNotificationsStatusState() =>
      Rx.merge([
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
        _$loadNotificationsSettingsEvent.startWith(null).switchMap((value) =>
            _notificationService
                .syncNotificationSettings()
                .then((_) => true)
                .asResultStream()),
      ]).setResultStateHandler(this).publish();

  @override
  Stream<Result<bool>> _mapToAreNotificationsEnabledState() => Rx.merge([
        _$loadNotificationsSettingsEvent.startWith(null),
        syncNotificationsStatus.whereSuccess(),
      ])
          .switchMap((value) =>
              _notificationService.areNotificationsEnabled().asResultStream())
          .setResultStateHandler(this)
          .shareReplay(maxSize: 1); {{#enable_pin_code}}
  
  @override
  Stream<bool> _mapToIsBiometricsAuthEnabledState() => _biometricsService
      .isBiometricsAuthEnabled()
      .asResultStream()
      .setResultStateHandler(this)
      .whereSuccess(); {{/enable_pin_code}}
}

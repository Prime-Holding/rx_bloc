{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

{{#enable_feature_onboarding}}
import '../../base/common_blocs/coordinator_bloc.dart';{{/enable_feature_onboarding}}
import '../../base/common_services/push_notifications_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';{{#enable_in_app_notifications}}
import '../../feature_in_app_notifications/services/in_app_notifications_service.dart';{{/enable_in_app_notifications}}

part 'profile_bloc.rxb.g.dart';

/// A contract class containing all events of the ProfileBloC.
abstract class ProfileBlocEvents {
  void toggleNotifications();
{{#enable_in_app_notifications}}
  void fetchUnreadNotifications();
{{/enable_in_app_notifications}}}

/// A contract class containing all states of the ProfileBloC.
abstract class ProfileBlocStates {
  /// The state representing the if the notifications are enabled
  ConnectableStream<Result<bool>> get areNotificationsEnabled;

  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;
{{#enable_in_app_notifications}}
  /// The count of unread in-app notifications
  Stream<int> get inAppNotificationCount;
{{/enable_in_app_notifications}}{{#enable_feature_onboarding}}

  /// State indicating that the phone number was updated
  @RxBlocIgnoreState()
  Stream<void> get phoneNumberUpdated;{{/enable_feature_onboarding}}
}

@RxBloc()
class ProfileBloc extends $ProfileBloc {
  ProfileBloc(
    this._notificationService,{{#enable_feature_onboarding}}
    this._coordinatorBloc,{{/enable_feature_onboarding}}{{#enable_in_app_notifications}}
    this._inAppNotificationsService,{{/enable_in_app_notifications}}
  ) {
    areNotificationsEnabled.connect().addTo(_compositeSubscription);
  }

  final PushNotificationsService _notificationService;{{#enable_feature_onboarding}}
  final CoordinatorBlocType _coordinatorBloc;{{/enable_feature_onboarding}}{{#enable_in_app_notifications}}
  final InAppNotificationsService _inAppNotificationsService;{{/enable_in_app_notifications}}

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;{{#enable_feature_onboarding}}

  @override
  Stream<void> get phoneNumberUpdated =>
      _coordinatorBloc.states.phoneNumberUpdated;{{/enable_feature_onboarding}}

  @override
  ConnectableStream<Result<bool>> _mapToAreNotificationsEnabledState() =>
      Rx.merge([
        _$toggleNotificationsEvent.switchMap((_) => _notificationService
            .toggleNotifications()
            .asResultStream()),
        _notificationService.areNotificationsEnabled().asResultStream(),
      ]).setResultStateHandler(this).publishReplay(maxSize: 1);
{{#enable_in_app_notifications}}
  @override
  Stream<int> _mapToInAppNotificationCountState() =>
      _$fetchUnreadNotificationsEvent.startWith(null).switchMap(
            (_) => _inAppNotificationsService
                .getUnreadCount()
                .asResultStream()
                .setResultStateHandler(this)
                .whereSuccess(),
          ).startWith(0);
{{/enable_in_app_notifications}}}

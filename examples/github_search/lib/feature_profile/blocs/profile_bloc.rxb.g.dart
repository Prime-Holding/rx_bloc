// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'profile_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class ProfileBlocType extends RxBlocTypeBase {
  ProfileBlocEvents get events;
  ProfileBlocStates get states;
}

/// [$ProfileBloc] extended by the [ProfileBloc]
/// @nodoc
abstract class $ProfileBloc extends RxBlocBase
    implements ProfileBlocEvents, ProfileBlocStates, ProfileBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [setNotifications]
  final _$setNotificationsEvent = PublishSubject<bool>();

  /// Тhe [Subject] where events sink to by calling [loadNotificationsSettings]
  final _$loadNotificationsSettingsEvent = PublishSubject<void>();

  /// The state of [areNotificationsEnabled] implemented in
  /// [_mapToAreNotificationsEnabledState]
  late final Stream<Result<bool>> _areNotificationsEnabledState =
      _mapToAreNotificationsEnabledState();

  /// The state of [syncNotificationsStatus] implemented in
  /// [_mapToSyncNotificationsStatusState]
  late final ConnectableStream<Result<bool>> _syncNotificationsStatusState =
      _mapToSyncNotificationsStatusState();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

  @override
  void setNotifications(bool enabled) => _$setNotificationsEvent.add(enabled);

  @override
  void loadNotificationsSettings() =>
      _$loadNotificationsSettingsEvent.add(null);

  @override
  Stream<Result<bool>> get areNotificationsEnabled =>
      _areNotificationsEnabledState;

  @override
  ConnectableStream<Result<bool>> get syncNotificationsStatus =>
      _syncNotificationsStatusState;

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<ErrorModel> get errors => _errorsState;

  Stream<Result<bool>> _mapToAreNotificationsEnabledState();

  ConnectableStream<Result<bool>> _mapToSyncNotificationsStatusState();

  Stream<bool> _mapToIsLoadingState();

  Stream<ErrorModel> _mapToErrorsState();

  @override
  ProfileBlocEvents get events => this;

  @override
  ProfileBlocStates get states => this;

  @override
  void dispose() {
    _$setNotificationsEvent.close();
    _$loadNotificationsSettingsEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

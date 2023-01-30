// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'notifications_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class NotificationsBlocType extends RxBlocTypeBase {
  NotificationsBlocEvents get events;
  NotificationsBlocStates get states;
}

/// [$NotificationsBloc] extended by the [NotificationsBloc]
/// {@nodoc}
abstract class $NotificationsBloc extends RxBlocBase
    implements
        NotificationsBlocEvents,
        NotificationsBlocStates,
        NotificationsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling
  /// [requestNotificationPermissions]
  final _$requestNotificationPermissionsEvent = PublishSubject<void>();

  /// Тhe [Subject] where events sink to by calling [sendMessage]
  final _$sendMessageEvent = PublishSubject<_SendMessageEventArgs>();

  /// The state of [permissionsAuthorized] implemented in
  /// [_mapToPermissionsAuthorizedState]
  late final Stream<bool> _permissionsAuthorizedState =
      _mapToPermissionsAuthorizedState();

  @override
  void requestNotificationPermissions() =>
      _$requestNotificationPermissionsEvent.add(null);

  @override
  void sendMessage(
    String message, {
    String? title,
    int? delay,
  }) =>
      _$sendMessageEvent.add(_SendMessageEventArgs(
        message,
        title: title,
        delay: delay,
      ));

  @override
  Stream<bool> get permissionsAuthorized => _permissionsAuthorizedState;

  Stream<bool> _mapToPermissionsAuthorizedState();

  @override
  NotificationsBlocEvents get events => this;

  @override
  NotificationsBlocStates get states => this;

  @override
  void dispose() {
    _$requestNotificationPermissionsEvent.close();
    _$sendMessageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [NotificationsBlocEvents.sendMessage] event
class _SendMessageEventArgs {
  const _SendMessageEventArgs(
    this.message, {
    this.title,
    this.delay,
  });

  final String message;

  final String? title;

  final int? delay;
}

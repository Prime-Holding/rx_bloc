// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'send_notifications_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class SendNotificationsBlocType extends RxBlocTypeBase {
  SendNotificationsBlocEvents get events;
  SendNotificationsBlocStates get states;
}

/// [$SendNotificationsBloc] extended by the [SendNotificationsBloc]
/// {@nodoc}
abstract class $SendNotificationsBloc extends RxBlocBase
    implements
        SendNotificationsBlocEvents,
        SendNotificationsBlocStates,
        SendNotificationsBlocType {
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
  void sendMessage(String message, {String? title, int? delay}) =>
      _$sendMessageEvent
          .add(_SendMessageEventArgs(message, title: title, delay: delay));

  @override
  Stream<bool> get permissionsAuthorized => _permissionsAuthorizedState;

  Stream<bool> _mapToPermissionsAuthorizedState();

  @override
  SendNotificationsBlocEvents get events => this;

  @override
  SendNotificationsBlocStates get states => this;

  @override
  void dispose() {
    _$requestNotificationPermissionsEvent.close();
    _$sendMessageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [SendNotificationsBlocEvents.sendMessage] event
class _SendMessageEventArgs {
  const _SendMessageEventArgs(this.message, {this.title, this.delay});

  final String message;

  final String? title;

  final int? delay;
}

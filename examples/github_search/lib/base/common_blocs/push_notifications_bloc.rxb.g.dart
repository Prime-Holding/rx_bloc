// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'push_notifications_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class PushNotificationsBlocType extends RxBlocTypeBase {
  PushNotificationsBlocEvents get events;
  PushNotificationsBlocStates get states;
}

/// [$PushNotificationsBloc] extended by the [PushNotificationsBloc]
/// @nodoc
abstract class $PushNotificationsBloc extends RxBlocBase
    implements
        PushNotificationsBlocEvents,
        PushNotificationsBlocStates,
        PushNotificationsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [tapOnEvent]
  final _$tapOnEventEvent = PublishSubject<NotificationModel>();

  @override
  void tapOnEvent(NotificationModel event) => _$tapOnEventEvent.add(event);

  @override
  PushNotificationsBlocEvents get events => this;

  @override
  PushNotificationsBlocStates get states => this;

  @override
  void dispose() {
    _$tapOnEventEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

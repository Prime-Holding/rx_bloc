// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'enter_message_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class EnterMessageBlocType extends RxBlocTypeBase {
  EnterMessageBlocEvents get events;
  EnterMessageBlocStates get states;
}

/// [$EnterMessageBloc] extended by the [EnterMessageBloc]
/// {@nodoc}
abstract class $EnterMessageBloc extends RxBlocBase
    implements
        EnterMessageBlocEvents,
        EnterMessageBlocStates,
        EnterMessageBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [setMessage]
  final _$setMessageEvent = PublishSubject<String>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

  /// The state of [message] implemented in [_mapToMessageState]
  late final Stream<String> _messageState = _mapToMessageState();

  @override
  void setMessage(String messages) => _$setMessageEvent.add(messages);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<ErrorModel> get errors => _errorsState;

  @override
  Stream<String> get message => _messageState;

  Stream<bool> _mapToIsLoadingState();

  Stream<ErrorModel> _mapToErrorsState();

  Stream<String> _mapToMessageState();

  @override
  EnterMessageBlocEvents get events => this;

  @override
  EnterMessageBlocStates get states => this;

  @override
  void dispose() {
    _$setMessageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

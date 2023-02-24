// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'deep_link_list_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class DeepLinkListBlocType extends RxBlocTypeBase {
  DeepLinkListBlocEvents get events;
  DeepLinkListBlocStates get states;
}

/// [$DeepLinkListBloc] extended by the [DeepLinkListBloc]
/// {@nodoc}
abstract class $DeepLinkListBloc extends RxBlocBase
    implements
        DeepLinkListBlocEvents,
        DeepLinkListBlocStates,
        DeepLinkListBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [fetchDeepLinkList]
  final _$fetchDeepLinkListEvent = BehaviorSubject<void>();

  /// Тhe [Subject] where events sink to by calling [setMessage]
  final _$setMessageEvent = PublishSubject<String>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<LoadingWithTag> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

  /// The state of [deepLinkList] implemented in [_mapToDeepLinkListState]
  late final Stream<Result<List<DeepLinkModel>>> _deepLinkListState =
      _mapToDeepLinkListState();

  /// The state of [message] implemented in [_mapToMessageState]
  late final Stream<String> _messageState = _mapToMessageState();

  @override
  void fetchDeepLinkList() => _$fetchDeepLinkListEvent.add(null);

  @override
  void setMessage(String message) => _$setMessageEvent.add(message);

  @override
  Stream<LoadingWithTag> get isLoading => _isLoadingState;

  @override
  Stream<ErrorModel> get errors => _errorsState;

  @override
  Stream<Result<List<DeepLinkModel>>> get deepLinkList => _deepLinkListState;

  @override
  Stream<String> get message => _messageState;

  Stream<LoadingWithTag> _mapToIsLoadingState();

  Stream<ErrorModel> _mapToErrorsState();

  Stream<Result<List<DeepLinkModel>>> _mapToDeepLinkListState();

  Stream<String> _mapToMessageState();

  @override
  DeepLinkListBlocEvents get events => this;

  @override
  DeepLinkListBlocStates get states => this;

  @override
  void dispose() {
    _$fetchDeepLinkListEvent.close();
    _$setMessageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'deep_link_details_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class DeepLinkDetailsBlocType extends RxBlocTypeBase {
  DeepLinkDetailsBlocEvents get events;
  DeepLinkDetailsBlocStates get states;
}

/// [$DeepLinkDetailsBloc] extended by the [DeepLinkDetailsBloc]
/// {@nodoc}
abstract class $DeepLinkDetailsBloc extends RxBlocBase
    implements
        DeepLinkDetailsBlocEvents,
        DeepLinkDetailsBlocStates,
        DeepLinkDetailsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [fetchDeepLinkDetailsById]
  final _$fetchDeepLinkDetailsByIdEvent = BehaviorSubject<String>();

  /// Тhe [Subject] where events sink to by calling [showDeepLinkDetails]
  final _$showDeepLinkDetailsEvent = BehaviorSubject<DeepLinkModel>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

  /// The state of [deepLink] implemented in [_mapToDeepLinkState]
  late final Stream<Result<DeepLinkModel>> _deepLinkState =
      _mapToDeepLinkState();

  @override
  void fetchDeepLinkDetailsById(String deepLinkId) =>
      _$fetchDeepLinkDetailsByIdEvent.add(deepLinkId);

  @override
  void showDeepLinkDetails(DeepLinkModel item) =>
      _$showDeepLinkDetailsEvent.add(item);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<ErrorModel> get errors => _errorsState;

  @override
  Stream<Result<DeepLinkModel>> get deepLink => _deepLinkState;

  Stream<bool> _mapToIsLoadingState();

  Stream<ErrorModel> _mapToErrorsState();

  Stream<Result<DeepLinkModel>> _mapToDeepLinkState();

  @override
  DeepLinkDetailsBlocEvents get events => this;

  @override
  DeepLinkDetailsBlocStates get states => this;

  @override
  void dispose() {
    _$fetchDeepLinkDetailsByIdEvent.close();
    _$showDeepLinkDetailsEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

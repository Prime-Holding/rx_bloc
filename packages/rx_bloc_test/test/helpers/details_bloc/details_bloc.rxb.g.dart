// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'details_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class DetailsBlocType extends RxBlocTypeBase {
  DetailsBlocEvents get events;
  DetailsBlocStates get states;
}

/// [$DetailsBloc] extended by the [DetailsBloc]
/// {@nodoc}
abstract class $DetailsBloc extends RxBlocBase
    implements DetailsBlocEvents, DetailsBlocStates, DetailsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [fetch]
  final _$fetchEvent = PublishSubject<void>();

  /// Тhe [Subject] where events sink to by calling [setEmail]
  final _$setEmailEvent = PublishSubject<String>();

  /// The state of [email] implemented in [_mapToEmailState]
  late final Stream<String> _emailState = _mapToEmailState();

  /// The state of [details] implemented in [_mapToDetailsState]
  late final Stream<String> _detailsState = _mapToDetailsState();

  @override
  void fetch() => _$fetchEvent.add(null);

  @override
  void setEmail(String email) => _$setEmailEvent.add(email);

  @override
  Stream<String> get email => _emailState;

  @override
  Stream<String> get details => _detailsState;

  Stream<String> _mapToEmailState();

  Stream<String> _mapToDetailsState();

  @override
  DetailsBlocEvents get events => this;

  @override
  DetailsBlocStates get states => this;

  @override
  void dispose() {
    _$fetchEvent.close();
    _$setEmailEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

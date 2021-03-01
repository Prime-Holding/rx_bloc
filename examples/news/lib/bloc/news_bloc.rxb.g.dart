// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'news_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class NewsBlocType extends RxBlocTypeBase {
  NewsBlocEvents get events;
  NewsBlocStates get states;
}

/// [$NewsBloc] extended by the [NewsBloc]
/// {@nodoc}
abstract class $NewsBloc extends RxBlocBase
    implements NewsBlocEvents, NewsBlocStates, NewsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [fetch]
  final _$fetchEvent = PublishSubject<void>();

  /// The state of [news] implemented in [_mapToNewsState]
  Stream<List<News>> _newsState;

  @override
  void fetch() => _$fetchEvent.add(null);

  @override
  Stream<List<News>> get news => _newsState ??= _mapToNewsState();

  Stream<List<News>> _mapToNewsState();

  @override
  NewsBlocEvents get events => this;

  @override
  NewsBlocStates get states => this;

  @override
  void dispose() {
    _$fetchEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

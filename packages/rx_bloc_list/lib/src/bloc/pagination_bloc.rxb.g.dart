// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'pagination_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class PaginationBlocType extends RxBlocTypeBase {
  PaginationBlocEvents get events;
  PaginationBlocStates get states;
}

/// [$PaginationBloc] extended by the [PaginationBloc]
/// {@nodoc}
abstract class $PaginationBloc extends RxBlocBase
    implements PaginationBlocEvents, PaginationBlocStates, PaginationBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [loadPage]
  final _$loadPageEvent = PublishSubject<bool>();

  @override
  void loadPage({bool reset = false}) => _$loadPageEvent.add(reset);

  @override
  PaginationBlocEvents get events => this;

  @override
  PaginationBlocStates get states => this;

  @override
  void dispose() {
    _$loadPageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

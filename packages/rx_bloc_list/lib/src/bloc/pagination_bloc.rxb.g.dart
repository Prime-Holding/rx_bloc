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

  /// Тhe [Subject] where events sink to by calling [refreshData]
  final _$refreshDataEvent = PublishSubject<void>();

  /// Тhe [Subject] where events sink to by calling [load]
  final _$loadEvent = PublishSubject<int>();

  @override
  void refreshData() => _$refreshDataEvent.add(null);

  @override
  void load([int page = -1]) => _$loadEvent.add(page);

  @override
  PaginationBlocEvents get events => this;

  @override
  PaginationBlocStates get states => this;

  @override
  void dispose() {
    _$refreshDataEvent.close();
    _$loadEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

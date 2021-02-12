// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'rx_bloc_to_be_generated.dart';

/// BlocForTestPurposeType class used for blocClass event and state access from widgets
/// {@nodoc}
abstract class BlocForTestPurposeType extends RxBlocTypeBase {
  BlocForTestPurposeEvents get events;
  BlocForTestPurposeStates get states;
}

/// $BlocForTestPurpose class - extended by the CounterBloc bloc
/// {@nodoc}
abstract class $BlocForTestPurpose extends RxBlocBase
    implements
        BlocForTestPurposeEvents,
        BlocForTestPurposeStates,
        BlocForTestPurposeType {
  final _$simpleMethodEvent = PublishSubject<void>();

  Stream<int> _countState;

  Stream<bool> _isLoadingState;

  Stream<String> _errorsState;

  @override
  void simpleMethod() => _$simpleMethodEvent.add(null);
  @override
  Stream<int> get count => _countState ??= _mapToCountState();
  @override
  Stream<bool> get isLoading => _isLoadingState ??= _mapToIsLoadingState();
  @override
  Stream<String> get errors => _errorsState ??= _mapToErrorsState();
  Stream<int> _mapToCountState();
  Stream<bool> _mapToIsLoadingState();
  Stream<String> _mapToErrorsState();
  @override
  BlocForTestPurposeEvents get events => this;
  @override
  BlocForTestPurposeStates get states => this;
  @override
  void dispose() {
    _$simpleMethodEvent.close();
    super.dispose();
  }
}

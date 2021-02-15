part of 'test_bloc.dart';

/// The code below will be automatically generated
/// for you by `rx_bloc_generator`.
///
/// This generated class usually resides in [file-name].rxb.g.dart.
/// Find more info at https://pub.dev/packages/rx_bloc_generator.
/// ********************GENERATED CODE**************************************
/// TestBlocType class used for bloc event and state access from widgets
abstract class TestBlocType extends RxBlocTypeBase {
  // ignore: public_member_api_docs
  TestBlocEvents get events;

  // ignore: public_member_api_docs
  TestBlocStates get states;
}

/// ${blocName}Bloc class - extended by the TestBloc bloc
abstract class $TestBloc extends RxBlocBase
    implements TestBlocEvents, TestBlocStates, TestBlocType {

  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  Stream<bool> _isLoadingState;

  @override
  Stream<bool> get isLoading => _isLoadingState ??= _mapToIsLoadingState();

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _errorsState;

  @override
  Stream<String> get errors => _errorsState ??= _mapToErrorsState();

  Stream<String> _mapToErrorsState();

  @override
  TestBlocEvents get events => this;

  @override
  TestBlocStates get states => this;

  /// Dispose of all the opened streams when the bloc is closed.
  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }
}
/// ********************GENERATED CODE END**************************************
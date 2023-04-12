import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';

part 'profile_dart_bloc.rxb.g.dart';
part 'profile_dart_bloc_extensions.dart';

/// A contract class containing all events of the ProfileDartBloC.
abstract class ProfileDartBlocEvents {
  /// TODO: Document the event
  void fetchData();
}

/// A contract class containing all states of the ProfileDartBloC.
abstract class ProfileDartBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// TODO: Document the state
  Stream<Result<String>> get data;
}

@RxBloc()
class ProfileDartBloc extends $ProfileDartBloc {
  @override
  Stream<Result<String>> _mapToDataState() => _$fetchDataEvent
      .startWith(null)
      .mapToData()
      .setResultStateHandler(this)
      .shareReplay(maxSize: 1);

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();


  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
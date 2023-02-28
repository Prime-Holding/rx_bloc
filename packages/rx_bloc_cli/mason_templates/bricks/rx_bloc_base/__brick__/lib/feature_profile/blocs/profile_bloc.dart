{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';

part 'profile_bloc.rxb.g.dart';

/// A contract class containing all events of the ProfileBloC.
abstract class ProfileBlocEvents {}

/// A contract class containing all states of the ProfileBloC.
abstract class ProfileBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;
}

@RxBloc()
class ProfileBloc extends $ProfileBloc {
  ProfileBloc();

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}

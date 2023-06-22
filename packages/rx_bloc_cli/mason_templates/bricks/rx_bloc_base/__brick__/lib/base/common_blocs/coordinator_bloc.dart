{{> licence.dart }}

import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../models/errors/error_model.dart';

part 'coordinator_bloc.rxb.g.dart';

part 'coordinator_bloc_extensions.dart';

abstract class CoordinatorEvents {
  void authenticated({required bool isAuthenticated});

{{#enable_feature_otp}}
  void otpConfirmed({required bool isOtpConfirmed});{{/enable_feature_otp}}


  void errorLogged({
    required ErrorModel error,
    String? stackTrace,
  });
}

abstract class CoordinatorStates {
  @RxBlocIgnoreState()
  Stream<bool> get isAuthenticated;

{{#enable_feature_otp}}
  @RxBlocIgnoreState()
  Stream<bool> get isOtpConfirmed;{{/enable_feature_otp}}
}

/// The coordinator bloc manages the communication between blocs.
///
/// The goals is to keep all blocs decoupled from each other
/// as the entire communication flow goes through this bloc.
@RxBloc()
class CoordinatorBloc extends $CoordinatorBloc {
  @override
  Stream<bool> get isAuthenticated => _$authenticatedEvent;

{{#enable_feature_otp}}
  @override
  Stream<bool> get isOtpConfirmed => _$otpConfirmedEvent;{{/enable_feature_otp}}
}

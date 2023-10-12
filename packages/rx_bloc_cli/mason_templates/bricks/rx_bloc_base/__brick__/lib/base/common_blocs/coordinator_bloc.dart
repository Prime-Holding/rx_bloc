{{> licence.dart }}

import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

{{#analytics}}
import '../../lib_analytics/models/log_event_model.dart';
{{/analytics}}
import '../models/errors/error_model.dart';

part 'coordinator_bloc.rxb.g.dart';

part 'coordinator_bloc_extensions.dart';

abstract class CoordinatorEvents {
  void authenticated({required bool isAuthenticated});

{{#enable_feature_otp}}
  void otpConfirmed({required bool isOtpConfirmed});{{/enable_feature_otp}}{{#enable_pin_code}}

  void pinCodeConfirmed({required bool isPinCodeConfirmed});

  void userLoggedOut();

  void checkUserLoggedIn();{{/enable_pin_code}}

  void errorLogged({
    required ErrorModel error,
    String? stackTrace,
  });

  {{#analytics}}
  void navigationChanged(String location);
  {{/analytics}}
}

abstract class CoordinatorStates {
  @RxBlocIgnoreState()
  Stream<bool> get isAuthenticated;

{{#enable_feature_otp}}
  @RxBlocIgnoreState()
  Stream<bool> get isOtpConfirmed;{{/enable_feature_otp}} {{#enable_pin_code}}

  @RxBlocIgnoreState()
  Stream<bool> get isPinCodeConfirmed;

  Stream<void> get userLogOut;

  @RxBlocIgnoreState()
  Stream<void> get userLoggedIn;{{/enable_pin_code}}

  {{#analytics}}
  @RxBlocIgnoreState()
  Stream<String> get navigationChange;

  Stream<LogEventModel> get errorLogEvent;
  {{/analytics}}
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
  Stream<bool> get isOtpConfirmed => _$otpConfirmedEvent;{{/enable_feature_otp}} {{#enable_pin_code}}

  @override
  Stream<bool> get isPinCodeConfirmed =>
  _$pinCodeConfirmedEvent.startWith(false);

  @override
  Stream<void> _mapToUserLogOutState() => _$userLoggedOutEvent;

  @override
  Stream<void> get userLoggedIn => _$checkUserLoggedInEvent; {{/enable_pin_code}}

  {{#analytics}}
  @override
  Stream<String> get navigationChange => _$navigationChangedEvent;

  @override
  Stream<LogEventModel> _mapToErrorLogEventState() =>
    _$errorLoggedEvent.map((e) => LogEventModel(
      error: e.error,
      stackTrace: e.stackTrace,
    ));
  {{/analytics}}

}

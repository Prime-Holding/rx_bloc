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

  void errorLogged({
    required ErrorModel error,
    String? stackTrace,
  });

  {{#analytics}}
  void navigationChanged(String location);
  {{/analytics}}{{#enable_feature_onboarding}}

  /// Event that signals that the phone number was updated
  void updatePhoneNumber();{{/enable_feature_onboarding}}
}

abstract class CoordinatorStates {
  @RxBlocIgnoreState()
  Stream<bool> get isAuthenticated;
  {{#analytics}}
  @RxBlocIgnoreState()
  Stream<String> get navigationChange;

  Stream<LogEventModel> get errorLogEvent;
  {{/analytics}}{{#enable_feature_onboarding}}

  /// State indicating that the phone number was updated
  @RxBlocIgnoreState()
  Stream<void> get phoneNumberUpdated;{{/enable_feature_onboarding}}
}

/// The coordinator bloc manages the communication between blocs.
///
/// The goals is to keep all blocs decoupled from each other
/// as the entire communication flow goes through this bloc.
@RxBloc()
class CoordinatorBloc extends $CoordinatorBloc {
  @override
  Stream<bool> get isAuthenticated => _$authenticatedEvent;{{#enable_feature_onboarding}}

  @override
  Stream<void> get phoneNumberUpdated => _$updatePhoneNumberEvent;{{/enable_feature_onboarding}}

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

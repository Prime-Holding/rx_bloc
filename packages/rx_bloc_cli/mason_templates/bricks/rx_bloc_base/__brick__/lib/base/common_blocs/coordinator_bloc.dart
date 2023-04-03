{{> licence.dart }}

import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

{{#enable_change_language}}
import 'package:widget_toolkit/language_picker.dart' show LanguageModel;{{/enable_change_language}}

import '../models/errors/error_model.dart';

part 'coordinator_bloc.rxb.g.dart';
part 'coordinator_bloc_extensions.dart';

abstract class CoordinatorEvents {
  void authenticated({required bool isAuthenticated});

  void errorLogged({
    required ErrorModel error,
    String? stackTrace,
  });
  {{#enable_change_language}}
  void setCurrentLanguage(LanguageModel model);{{/enable_change_language}}
}

abstract class CoordinatorStates {
  @RxBlocIgnoreState()
  Stream<bool> get isAuthenticated;
  {{#enable_change_language}}
  Stream<LanguageModel> get currentLanguage;{{/enable_change_language}}
}

/// The coordinator bloc manages the communication between blocs.
///
/// The goals is to keep all blocs decoupled from each other
/// as the entire communication flow goes through this bloc.
@RxBloc()
class CoordinatorBloc extends $CoordinatorBloc {
  @override
  Stream<bool> get isAuthenticated => _$authenticatedEvent;
  {{#enable_change_language}}
  @override
  Stream<LanguageModel> _mapToCurrentLanguageState() =>
      _$setCurrentLanguageEvent;{{/enable_change_language}}
}

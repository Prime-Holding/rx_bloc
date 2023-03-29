{{> licence.dart }}

import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

{{#enable_internationalisation}}
import 'package:widget_toolkit/language_picker.dart' show LanguageModel;{{/enable_internationalisation}}

import '../models/errors/error_model.dart';

part 'coordinator_bloc.rxb.g.dart';
part 'coordinator_bloc_extensions.dart';

abstract class CoordinatorEvents {
  void authenticated({required bool isAuthenticated});

  void errorLogged({
    required ErrorModel error,
    String? stackTrace,
  });
  {{#enable_internationalisation}}
  void setCurrentLanguage(LanguageModel model);{{/enable_internationalisation}}
}

abstract class CoordinatorStates {
  @RxBlocIgnoreState()
  Stream<bool> get isAuthenticated;
  {{#enable_internationalisation}}
  Stream<LanguageModel> get currentLanguage;{{/enable_internationalisation}}
}

/// The coordinator bloc manages the communication between blocs.
///
/// The goals is to keep all blocs decoupled from each other
/// as the entire communication flow goes through this bloc.
@RxBloc()
class CoordinatorBloc extends $CoordinatorBloc {
  @override
  Stream<bool> get isAuthenticated => _$authenticatedEvent;
  {{#enable_internationalisation}}
  @override
  Stream<LanguageModel> _mapToCurrentLanguageState() =>
      _$setCurrentLanguageEvent;{{/enable_internationalisation}}
}

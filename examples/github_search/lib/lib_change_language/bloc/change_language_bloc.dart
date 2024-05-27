// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:widget_toolkit/language_picker.dart' hide ErrorModel;

import '../services/app_language_service.dart';

part 'change_language_bloc.rxb.g.dart';

/// A contract class containing all events of the ChangeLanguageBloC.
abstract class ChangeLanguageBlocEvents {
  void setCurrentLanguage(LanguageModel model);
}

/// A contract class containing all states of the ChangeLanguageBloC.
abstract class ChangeLanguageBlocStates {
  ConnectableStream<LanguageModel> get currentLanguage;
}

@RxBloc()
class ChangeLanguageBloc extends $ChangeLanguageBloc {
  ChangeLanguageBloc({required this.languageService}) {
    currentLanguage.connect().addTo(_compositeSubscription);
  }

  final AppLanguageService languageService;

  final Stream<LanguageModel?> _initialLanguage =
      PublishSubject<LanguageModel?>();

  @override
  ConnectableStream<LanguageModel> _mapToCurrentLanguageState() => Rx.merge([
        _$setCurrentLanguageEvent,
        _initialLanguage
            .startWith(null)
            .switchMap((_) => languageService.getCurrent().asResultStream())
            .whereSuccess()
            .asBroadcastStream(),
      ]).publish();
}

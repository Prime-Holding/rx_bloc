// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'change_language_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class ChangeLanguageBlocType extends RxBlocTypeBase {
  ChangeLanguageBlocEvents get events;
  ChangeLanguageBlocStates get states;
}

/// [$ChangeLanguageBloc] extended by the [ChangeLanguageBloc]
/// @nodoc
abstract class $ChangeLanguageBloc extends RxBlocBase
    implements
        ChangeLanguageBlocEvents,
        ChangeLanguageBlocStates,
        ChangeLanguageBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [setCurrentLanguage]
  final _$setCurrentLanguageEvent = PublishSubject<LanguageModel>();

  /// The state of [currentLanguage] implemented in [_mapToCurrentLanguageState]
  late final ConnectableStream<LanguageModel> _currentLanguageState =
      _mapToCurrentLanguageState();

  @override
  void setCurrentLanguage(LanguageModel model) =>
      _$setCurrentLanguageEvent.add(model);

  @override
  ConnectableStream<LanguageModel> get currentLanguage => _currentLanguageState;

  ConnectableStream<LanguageModel> _mapToCurrentLanguageState();

  @override
  ChangeLanguageBlocEvents get events => this;

  @override
  ChangeLanguageBlocStates get states => this;

  @override
  void dispose() {
    _$setCurrentLanguageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

{{> licence.dart }}

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../l10n/generated/l10n.dart';

class AppI18n extends S {
  static Locale? locale;

  static const AppI18nDelegate delegate = AppI18nDelegate();

  AppI18n();

  static AppI18n of(BuildContext context) {
    final instance = Localizations.of<AppI18n>(context, AppI18n);
    assert(
      instance != null,
      'No instance of AppI18n present in the widget tree. Did you add AppI18n.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  /// Map of translation keys to their getter functions.
  /// This allows dynamic lookup without maintaining a switch statement.
  late final Map<String, String? Function()> _translationMap = {
    'accessDenied': () => accessDenied,
    'badRequest': () => badRequest,
    'network': () => network,
    'noConnection': () => noConnection,
    'connectionRefused': () => connectionRefused,
    'notFound': () => notFound,
    'conflict': () => conflict,
    'server': () => server,
    'unknown': () => unknown,
    'invalidEmail': () => invalidEmail,
    'passwordLength': () => passwordLength,
    'wrongEmailOrPassword': () => wrongEmailOrPassword,
    'wrongPin': () => wrongPin,
    'pinCodeMismatch': () => pinCodeMismatch,
    'invalidMessage': () => invalidMessage,
    'tooLong': () => tooLong,
    'googleAuthError': () => googleAuthError,
    'tooShort': () => tooShort,
    'notificationsDisabledMessage': () => notificationsDisabledMessage,
    'noMailApp': () => noMailApp,
    'invalidUrl': () => invalidUrl,
    'notImplemented': () => notImplemented,
  };

  /// Returns a translation string based on the provided key.
  /// Returns null if the key is not found.
  /// This method dynamically looks up keys from the generated S class.
  String? getString(String key, [Map<String, String>? placeholders]) {
    // Handle special case for requiredField which needs placeholders
    if (key == 'requiredField') {
      return requiredField(placeholders?['fieldName'] ?? '');
    }

    // Look up the key in the map
    final getter = _translationMap[key];
    return getter?.call();
  }
}

class AppI18nDelegate extends LocalizationsDelegate<AppI18n> {
  const AppI18nDelegate();

  List<Locale> get supportedLocales => S.delegate.supportedLocales;

  @override
  Future<AppI18n> load(Locale locale) async {
    await S.load(locale);
    AppI18n.locale = locale;
    return SynchronousFuture<AppI18n>(AppI18n());
  }

  @override
  bool isSupported(Locale locale) => true;

  @override
  bool shouldReload(AppI18nDelegate old) => true;
}

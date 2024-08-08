{{> licence.dart }}

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../assets.dart';{{#enable_feature_counter}}
import 'network_lookup/counter_lookup.dart';{{/enable_feature_counter}}{{#enable_feature_deeplinks}}
import 'network_lookup/deep_link_lookup.dart';
import 'network_lookup/enter_message_lookup.dart';{{/enable_feature_deeplinks}}
import 'network_lookup/error_lookup.dart';
import 'network_lookup/field_lookup.dart';{{#enable_change_language}}
import 'network_lookup/lib_change_language_lookup.dart';{{/enable_change_language}}{{#enable_dev_menu}}
import 'network_lookup/lib_dev_menu_lookup.dart';{{/enable_dev_menu}}{{#enable_pin_code}}
import 'network_lookup/lib_pin_code_lookup.dart';{{/enable_pin_code}}
import 'network_lookup/lib_router_lookup.dart';{{#has_authentication}}
import 'network_lookup/login_lookup.dart';{{/has_authentication}}
import 'network_lookup/notifications_lookup.dart';{{#enable_feature_otp}}
import 'network_lookup/otp_lookup.dart';{{/enable_feature_otp}}
import 'network_lookup/profile_lookup.dart';{{#enable_mfa}}
import 'network_lookup/mfa_lookup.dart';{{/enable_mfa}}
import 'network_lookup/util.dart';{{#enable_feature_widget_toolkit}}
import 'network_lookup/widget_toolkit_lookup.dart';{{/enable_feature_widget_toolkit}}

class AppI18n extends I18n {
  static Locale? locale;

  static const AppI18nDelegate delegate = AppI18nDelegate();

  AppI18n() : super(AppI18nLookup());

  static AppI18n of(BuildContext context) =>
      Localizations.of<AppI18n>(context, AppI18n)!;
}

class AppI18nDelegate extends LocalizationsDelegate<AppI18n> {
  const AppI18nDelegate();

  @override
  Future<AppI18n> load(Locale locale) {
    I18n.delegate.load(locale);
    AppI18n.locale = locale;
    return SynchronousFuture<AppI18n>(AppI18n());
  }

  @override
  bool isSupported(Locale locale) => true;

  @override
  bool shouldReload(AppI18nDelegate old) => true;
}

class AppI18nLookup extends I18nLookup {

  /// region Boilerplate

  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('', key, placeholders) ??
    getFromBundle(AppI18n.locale?.languageCode)
        .getString(key, placeholders)!;
  }

  I18n? bundledI18n;

  I18n getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n = I18n(I18nLookup_bg());
        break;
        case 'en':
          bundledI18n = I18n(I18nLookup_en());
        break;
        default:
          bundledI18n = I18n(I18nLookup_en());
        break;
      }
    }
    return bundledI18n!;
  }

  /// endregion

  /// region Lookup overrides

  @override
  I18nErrorLookup createErrorLookup() => AppI18nErrorLookup();

  @override
  I18nFieldLookup createFieldLookup() => AppI18nFieldLookup();{{#enable_login}}

  @override
  I18nFeatureLoginLookup createFeatureLoginLookup() => AppI18nLoginLookup();

{{/enable_login}}{{#enable_mfa}}
  @override
  I18nFeatureMfaLookup createFeatureMfaLookup() =>
      AppI18nMfaLookup(); {{/enable_mfa}} {{#enable_feature_counter}}

  @override
  I18nFeatureCounterLookup createFeatureCounterLookup() =>
      AppI18nCounterLookup();{{/enable_feature_counter}}{{#enable_feature_deeplinks}}

  @override
  I18nFeatureDeepLinkLookup createFeatureDeepLinkLookup() =>
      AppI18nDeepLinkLookup();

  @override
  I18nFeatureEnterMessageLookup createFeatureEnterMessageLookup() =>
      AppI18nEnterMessageLookup();{{/enable_feature_deeplinks}}

  @override
  I18nFeatureNotificationsLookup createFeatureNotificationsLookup() =>
      AppI18nNotificationsLookup();{{#enable_feature_otp}}

  @override
  I18nFeatureOtpLookup createFeatureOtpLookup() => AppI18nOtpLookup();{{/enable_feature_otp}}

  @override
  I18nFeatureProfileLookup createFeatureProfileLookup() =>
      AppI18nProfileLookup();{{#enable_feature_widget_toolkit}}

  @override
  I18nFeatureWidgetToolkitLookup createFeatureWidgetToolkitLookup() =>
      AppI18nWidgetToolkitLookup();{{/enable_feature_widget_toolkit}}{{#enable_change_language}}

  @override
  I18nLibChangeLanguageLookup createLibChangeLanguageLookup() =>
      AppI18nLibChangeLanguageLookup();{{/enable_change_language}} {{#enable_dev_menu}}

  @override
  I18nLibDevMenuLookup createLibDevMenuLookup() => AppI18nLibDevMenuLookup();{{/enable_dev_menu}} {{#enable_pin_code}}

  @override
  I18nLibPinCodeLookup createLibPinCodeLookup() => AppI18nLibPinCodeLookup();{{/enable_pin_code}}

  @override
  I18nLibRouterLookup createLibRouterLookup() => AppI18nLibRouterLookup();

  /// endregion

  // TODO: Add your custom lookups here
  // First create your lookup file inside the `network_lookup` directory
  // And then wire it up with here as an override

}

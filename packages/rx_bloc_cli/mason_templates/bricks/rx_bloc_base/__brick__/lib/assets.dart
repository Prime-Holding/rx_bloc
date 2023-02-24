import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class I18n {
  final I18nLookup _lookup;

  I18n(this._lookup)
      : error = I18nError(_lookup.createErrorLookup()),
        featureCounter =
            I18nFeatureCounter(_lookup.createFeatureCounterLookup()),
        featureLogin = I18nFeatureLogin(_lookup.createFeatureLoginLookup()),
        featureNotifications = I18nFeatureNotifications(
            _lookup.createFeatureNotificationsLookup()),
        featureEnterMessage =
            I18nFeatureEnterMessage(_lookup.createFeatureEnterMessageLookup()),
        field = I18nField(_lookup.createFieldLookup());

  static Locale? _locale;

  static Locale? get currentLocale => _locale;

  /// add custom locale lookup which will be called first
  static I18nLookup? customLookup;

  static const I18nDelegate delegate = I18nDelegate();

  static I18n of(BuildContext context) =>
      Localizations.of<I18n>(context, I18n)!;

  static List<Locale> get supportedLocales {
    return const <Locale>[Locale("en"), Locale("es")];
  }

  final I18nError error;

  final I18nFeatureCounter featureCounter;

  final I18nFeatureLogin featureLogin;

  final I18nFeatureNotifications featureNotifications;

  final I18nFeatureEnterMessage featureEnterMessage;

  final I18nField field;

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Reload"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Reload"</td>
  ///   </tr>
  ///  </table>
  ///
  String get reload {
    return customLookup?.reload ?? _lookup.reload;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"OK"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"OK"</td>
  ///   </tr>
  ///  </table>
  ///
  String get ok {
    return customLookup?.ok ?? _lookup.ok;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Close"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Close"</td>
  ///   </tr>
  ///  </table>
  ///
  String get close {
    return customLookup?.close ?? _lookup.close;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Error occurred"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Error occurred"</td>
  ///   </tr>
  ///  </table>
  ///
  String get errorState {
    return customLookup?.errorState ?? _lookup.errorState;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Loading..."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Loading..."</td>
  ///   </tr>
  ///  </table>
  ///
  String get loadingState {
    return customLookup?.loadingState ?? _lookup.loadingState;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Reset password"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Reset password"</td>
  ///   </tr>
  ///  </table>
  ///
  String get resetPassword {
    return customLookup?.resetPassword ?? _lookup.resetPassword;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Enter message"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Enter message"</td>
  ///   </tr>
  ///  </table>
  ///
  String get pageWithResult {
    return customLookup?.pageWithResult ?? _lookup.pageWithResult;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Deep link flow"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Deep link flow"</td>
  ///   </tr>
  ///  </table>
  ///
  String get deepLinkFlowPageTitle {
    return customLookup?.deepLinkFlowPageTitle ?? _lookup.deepLinkFlowPageTitle;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Try again"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Try again"</td>
  ///   </tr>
  ///  </table>
  ///
  String get tryAgain {
    return customLookup?.tryAgain ?? _lookup.tryAgain;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Confirm"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Confirm"</td>
  ///   </tr>
  ///  </table>
  ///
  String get confirm {
    return customLookup?.confirm ?? _lookup.confirm;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Submit"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Submit"</td>
  ///   </tr>
  ///  </table>
  ///
  String get submit {
    return customLookup?.submit ?? _lookup.submit;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Counter"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Counter"</td>
  ///   </tr>
  ///  </table>
  ///
  String get navCounter {
    return customLookup?.navCounter ?? _lookup.navCounter;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Links"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Links"</td>
  ///   </tr>
  ///  </table>
  ///
  String get navLinks {
    return customLookup?.navLinks ?? _lookup.navLinks;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Profile"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Profile"</td>
  ///   </tr>
  ///  </table>
  ///
  String get navProfile {
    return customLookup?.navProfile ?? _lookup.navProfile;
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nKeys.reload:
        return reload;
      case I18nKeys.ok:
        return ok;
      case I18nKeys.close:
        return close;
      case I18nKeys.errorState:
        return errorState;
      case I18nKeys.loadingState:
        return loadingState;
      case I18nKeys.resetPassword:
        return resetPassword;
      case I18nKeys.pageWithResult:
        return pageWithResult;
      case I18nKeys.deepLinkFlowPageTitle:
        return deepLinkFlowPageTitle;
      case I18nKeys.tryAgain:
        return tryAgain;
      case I18nKeys.confirm:
        return confirm;
      case I18nKeys.submit:
        return submit;
      case I18nKeys.navCounter:
        return navCounter;
      case I18nKeys.navLinks:
        return navLinks;
      case I18nKeys.navProfile:
        return navProfile;
    }
    return null;
  }
}

class I18nError {
  I18nError(this._lookup);

  final I18nErrorLookup _lookup;

  /// add custom locale lookup which will be called first
  static I18nErrorLookup? customLookup;

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"You don\'t have access to this resource."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"You don\'t have access to this resource."</td>
  ///   </tr>
  ///  </table>
  ///
  String get accessDenied {
    return customLookup?.accessDenied ?? _lookup.accessDenied;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"A network error occurred."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"A network error occurred."</td>
  ///   </tr>
  ///  </table>
  ///
  String get network {
    return customLookup?.network ?? _lookup.network;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"It looks like your device is not connected to the internet. Please check your settings."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"It looks like your device is not connected to the internet. Please check your settings."</td>
  ///   </tr>
  ///  </table>
  ///
  String get noConnection {
    return customLookup?.noConnection ?? _lookup.noConnection;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Unable to connect to server. Connection refused."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Unable to connect to server. Connection refused."</td>
  ///   </tr>
  ///  </table>
  ///
  String get connectionRefused {
    return customLookup?.connectionRefused ?? _lookup.connectionRefused;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Resource not found."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Resource not found."</td>
  ///   </tr>
  ///  </table>
  ///
  String get notFound {
    return customLookup?.notFound ?? _lookup.notFound;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"An error occurred and the request could not be processed. Please try again later."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"An error occurred and the request could not be processed. Please try again later."</td>
  ///   </tr>
  ///  </table>
  ///
  String get server {
    return customLookup?.server ?? _lookup.server;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Oops, something went wrong. Please try again."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Oops, something went wrong. Please try again."</td>
  ///   </tr>
  ///  </table>
  ///
  String get unknown {
    return customLookup?.unknown ?? _lookup.unknown;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"{fieldName} should not be empty"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"{fieldName} should not be empty"</td>
  ///   </tr>
  ///  </table>
  ///
  String requiredField(String fieldName) {
    return customLookup?.requiredField(fieldName) ??
        _lookup.requiredField(fieldName);
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Please enter a valid email"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Please enter a valid email"</td>
  ///   </tr>
  ///  </table>
  ///
  String get invalidEmail {
    return customLookup?.invalidEmail ?? _lookup.invalidEmail;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Password should be at least 6 characters long"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Password should be at least 6 characters long"</td>
  ///   </tr>
  ///  </table>
  ///
  String get passwordLength {
    return customLookup?.passwordLength ?? _lookup.passwordLength;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Wrong email or password"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Wrong email or password"</td>
  ///   </tr>
  ///  </table>
  ///
  String get wrongEmailOrPassword {
    return customLookup?.wrongEmailOrPassword ?? _lookup.wrongEmailOrPassword;
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nErrorKeys.accessDenied:
        return accessDenied;
      case I18nErrorKeys.network:
        return network;
      case I18nErrorKeys.noConnection:
        return noConnection;
      case I18nErrorKeys.connectionRefused:
        return connectionRefused;
      case I18nErrorKeys.notFound:
        return notFound;
      case I18nErrorKeys.server:
        return server;
      case I18nErrorKeys.unknown:
        return unknown;
      case I18nErrorKeys.requiredField:
        return requiredField(placeholders?["fieldName"] ?? "");
      case I18nErrorKeys.invalidEmail:
        return invalidEmail;
      case I18nErrorKeys.passwordLength:
        return passwordLength;
      case I18nErrorKeys.wrongEmailOrPassword:
        return wrongEmailOrPassword;
    }
    return null;
  }
}

class I18nFeatureCounter {
  I18nFeatureCounter(this._lookup);

  final I18nFeatureCounterLookup _lookup;

  /// add custom locale lookup which will be called first
  static I18nFeatureCounterLookup? customLookup;

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Counter"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Counter"</td>
  ///   </tr>
  ///  </table>
  ///
  String get counterAppBarTitle {
    return customLookup?.counterAppBarTitle ?? _lookup.counterAppBarTitle;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Counter sample"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Counter sample"</td>
  ///   </tr>
  ///  </table>
  ///
  String get counterPageTitle {
    return customLookup?.counterPageTitle ?? _lookup.counterPageTitle;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Increment"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Increment"</td>
  ///   </tr>
  ///  </table>
  ///
  String get increment {
    return customLookup?.increment ?? _lookup.increment;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Decrement"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Decrement"</td>
  ///   </tr>
  ///  </table>
  ///
  String get decrement {
    return customLookup?.decrement ?? _lookup.decrement;
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nFeatureCounterKeys.counterAppBarTitle:
        return counterAppBarTitle;
      case I18nFeatureCounterKeys.counterPageTitle:
        return counterPageTitle;
      case I18nFeatureCounterKeys.increment:
        return increment;
      case I18nFeatureCounterKeys.decrement:
        return decrement;
    }
    return null;
  }
}

class I18nFeatureLogin {
  I18nFeatureLogin(this._lookup);

  final I18nFeatureLoginLookup _lookup;

  /// add custom locale lookup which will be called first
  static I18nFeatureLoginLookup? customLookup;

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Login sample"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Login sample"</td>
  ///   </tr>
  ///  </table>
  ///
  String get loginPageTitle {
    return customLookup?.loginPageTitle ?? _lookup.loginPageTitle;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Log in"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Log in"</td>
  ///   </tr>
  ///  </table>
  ///
  String get logIn {
    return customLookup?.logIn ?? _lookup.logIn;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Log out"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Log out"</td>
  ///   </tr>
  ///  </table>
  ///
  String get logOut {
    return customLookup?.logOut ?? _lookup.logOut;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Profile"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Profile"</td>
  ///   </tr>
  ///  </table>
  ///
  String get profile {
    return customLookup?.profile ?? _lookup.profile;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Notifications"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Notifications"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notifications {
    return customLookup?.notifications ?? _lookup.notifications;
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nFeatureLoginKeys.loginPageTitle:
        return loginPageTitle;
      case I18nFeatureLoginKeys.logIn:
        return logIn;
      case I18nFeatureLoginKeys.logOut:
        return logOut;
      case I18nFeatureLoginKeys.profile:
        return profile;
      case I18nFeatureLoginKeys.notifications:
        return notifications;
    }
    return null;
  }
}

class I18nFeatureNotifications {
  I18nFeatureNotifications(this._lookup);

  final I18nFeatureNotificationsLookup _lookup;

  /// add custom locale lookup which will be called first
  static I18nFeatureNotificationsLookup? customLookup;

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Notification sample"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Notification sample"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationPageTitle {
    return customLookup?.notificationPageTitle ?? _lookup.notificationPageTitle;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Seems that you have denied notifications on this device. In order for us to show notifications, they need to be manually enabled from the device settings."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Seems that you have denied notifications on this device. In order for us to show notifications, they need to be manually enabled from the device settings."</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationsPermissionsDenied {
    return customLookup?.notificationsPermissionsDenied ??
        _lookup.notificationsPermissionsDenied;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Request notification permissions"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Request notification permissions"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationPermissionRequestText {
    return customLookup?.notificationPermissionRequestText ??
        _lookup.notificationPermissionRequestText;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Show notification"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Show notification"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationShowText {
    return customLookup?.notificationShowText ?? _lookup.notificationShowText;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Show notification after 5 seconds"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Show notification after 5 seconds"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationShowDelayedText {
    return customLookup?.notificationShowDelayedText ??
        _lookup.notificationShowDelayedText;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"In order to receive push notifications on your device, you need first to grant access to them. This applies for iOS and Web, as the permissions on Android are granted upfront."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"In order to receive push notifications on your device, you need first to grant access to them. This applies for iOS and Web, as the permissions on Android are granted upfront."</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationsPageDescription {
    return customLookup?.notificationsPageDescription ??
        _lookup.notificationsPageDescription;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"When Firebase Cloud Messaging (FCM) is initialized, a FCM token is generated for the device. You can use this token to receive notifications while the app is in foreground, background or even terminated."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"When Firebase Cloud Messaging (FCM) is initialized, a FCM token is generated for the device. You can use this token to receive notifications while the app is in foreground, background or even terminated."</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationsPageConfig {
    return customLookup?.notificationsPageConfig ??
        _lookup.notificationsPageConfig;
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nFeatureNotificationsKeys.notificationPageTitle:
        return notificationPageTitle;
      case I18nFeatureNotificationsKeys.notificationsPermissionsDenied:
        return notificationsPermissionsDenied;
      case I18nFeatureNotificationsKeys.notificationPermissionRequestText:
        return notificationPermissionRequestText;
      case I18nFeatureNotificationsKeys.notificationShowText:
        return notificationShowText;
      case I18nFeatureNotificationsKeys.notificationShowDelayedText:
        return notificationShowDelayedText;
      case I18nFeatureNotificationsKeys.notificationsPageDescription:
        return notificationsPageDescription;
      case I18nFeatureNotificationsKeys.notificationsPageConfig:
        return notificationsPageConfig;
    }
    return null;
  }
}

class I18nFeatureEnterMessage {
  I18nFeatureEnterMessage(this._lookup);

  final I18nFeatureEnterMessageLookup _lookup;

  /// add custom locale lookup which will be called first
  static I18nFeatureEnterMessageLookup? customLookup;

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Message"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Message"</td>
  ///   </tr>
  ///  </table>
  ///
  String get fieldMessageLabel {
    return customLookup?.fieldMessageLabel ?? _lookup.fieldMessageLabel;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Enter your message"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Enter your message"</td>
  ///   </tr>
  ///  </table>
  ///
  String get fieldHintMessage {
    return customLookup?.fieldHintMessage ?? _lookup.fieldHintMessage;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"The purpose of this page is to showcase how to return data to the parent page and process it. Enter your message and press the submit button."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"The purpose of this page is to showcase how to return data to the parent page and process it. Enter your message and press the submit button."</td>
  ///   </tr>
  ///  </table>
  ///
  String get pageDescription {
    return customLookup?.pageDescription ?? _lookup.pageDescription;
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nFeatureEnterMessageKeys.fieldMessageLabel:
        return fieldMessageLabel;
      case I18nFeatureEnterMessageKeys.fieldHintMessage:
        return fieldHintMessage;
      case I18nFeatureEnterMessageKeys.pageDescription:
        return pageDescription;
    }
    return null;
  }
}

class I18nField {
  I18nField(this._lookup);

  final I18nFieldLookup _lookup;

  /// add custom locale lookup which will be called first
  static I18nFieldLookup? customLookup;

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Email"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Email"</td>
  ///   </tr>
  ///  </table>
  ///
  String get email {
    return customLookup?.email ?? _lookup.email;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Password"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">es</td>
  ///     <td>"Password"</td>
  ///   </tr>
  ///  </table>
  ///
  String get password {
    return customLookup?.password ?? _lookup.password;
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nFieldKeys.email:
        return email;
      case I18nFieldKeys.password:
        return password;
    }
    return null;
  }
}

class I18nKeys {
  static const String reload = "reload";
  static const String ok = "ok";
  static const String close = "close";
  static const String errorState = "errorState";
  static const String loadingState = "loadingState";
  static const String resetPassword = "resetPassword";
  static const String pageWithResult = "pageWithResult";
  static const String deepLinkFlowPageTitle = "deepLinkFlowPageTitle";
  static const String tryAgain = "tryAgain";
  static const String confirm = "confirm";
  static const String submit = "submit";
  static const String navCounter = "navCounter";
  static const String navLinks = "navLinks";
  static const String navProfile = "navProfile";
}

class I18nErrorKeys {
  static const String accessDenied = "accessDenied";
  static const String network = "network";
  static const String noConnection = "noConnection";
  static const String connectionRefused = "connectionRefused";
  static const String notFound = "notFound";
  static const String server = "server";
  static const String unknown = "unknown";
  static const String requiredField = "requiredField";
  static const String invalidEmail = "invalidEmail";
  static const String passwordLength = "passwordLength";
  static const String wrongEmailOrPassword = "wrongEmailOrPassword";
}

class I18nFeatureCounterKeys {
  static const String counterAppBarTitle = "counterAppBarTitle";
  static const String counterPageTitle = "counterPageTitle";
  static const String increment = "increment";
  static const String decrement = "decrement";
}

class I18nFeatureLoginKeys {
  static const String loginPageTitle = "loginPageTitle";
  static const String logIn = "logIn";
  static const String logOut = "logOut";
  static const String profile = "profile";
  static const String notifications = "notifications";
}

class I18nFeatureNotificationsKeys {
  static const String notificationPageTitle = "notificationPageTitle";
  static const String notificationsPermissionsDenied =
      "notificationsPermissionsDenied";
  static const String notificationPermissionRequestText =
      "notificationPermissionRequestText";
  static const String notificationShowText = "notificationShowText";
  static const String notificationShowDelayedText =
      "notificationShowDelayedText";
  static const String notificationsPageDescription =
      "notificationsPageDescription";
  static const String notificationsPageConfig = "notificationsPageConfig";
}

class I18nFeatureEnterMessageKeys {
  static const String fieldMessageLabel = "fieldMessageLabel";
  static const String fieldHintMessage = "fieldHintMessage";
  static const String pageDescription = "pageDescription";
}

class I18nFieldKeys {
  static const String email = "email";
  static const String password = "password";
}

class I18nLookup {
  String getString(String key, [Map<String, String>? placeholders]) {
    throw UnimplementedError("I18nLookup.getString");
  }

  String get reload {
    return getString(I18nKeys.reload);
  }

  String get ok {
    return getString(I18nKeys.ok);
  }

  String get close {
    return getString(I18nKeys.close);
  }

  String get errorState {
    return getString(I18nKeys.errorState);
  }

  String get loadingState {
    return getString(I18nKeys.loadingState);
  }

  String get resetPassword {
    return getString(I18nKeys.resetPassword);
  }

  String get pageWithResult {
    return getString(I18nKeys.pageWithResult);
  }

  String get deepLinkFlowPageTitle {
    return getString(I18nKeys.deepLinkFlowPageTitle);
  }

  String get tryAgain {
    return getString(I18nKeys.tryAgain);
  }

  String get confirm {
    return getString(I18nKeys.confirm);
  }

  String get submit {
    return getString(I18nKeys.submit);
  }

  String get navCounter {
    return getString(I18nKeys.navCounter);
  }

  String get navLinks {
    return getString(I18nKeys.navLinks);
  }

  String get navProfile {
    return getString(I18nKeys.navProfile);
  }

  I18nErrorLookup createErrorLookup() => I18nErrorLookup();

  I18nFeatureCounterLookup createFeatureCounterLookup() =>
      I18nFeatureCounterLookup();

  I18nFeatureLoginLookup createFeatureLoginLookup() => I18nFeatureLoginLookup();

  I18nFeatureNotificationsLookup createFeatureNotificationsLookup() =>
      I18nFeatureNotificationsLookup();

  I18nFeatureEnterMessageLookup createFeatureEnterMessageLookup() =>
      I18nFeatureEnterMessageLookup();

  I18nFieldLookup createFieldLookup() => I18nFieldLookup();
}

class I18nErrorLookup {
  String getString(String key, [Map<String, String>? placeholders]) {
    throw UnimplementedError("I18nErrorLookup.getString");
  }

  String get accessDenied {
    return getString(I18nErrorKeys.accessDenied);
  }

  String get network {
    return getString(I18nErrorKeys.network);
  }

  String get noConnection {
    return getString(I18nErrorKeys.noConnection);
  }

  String get connectionRefused {
    return getString(I18nErrorKeys.connectionRefused);
  }

  String get notFound {
    return getString(I18nErrorKeys.notFound);
  }

  String get server {
    return getString(I18nErrorKeys.server);
  }

  String get unknown {
    return getString(I18nErrorKeys.unknown);
  }

  String requiredField(String fieldName) {
    return getString(I18nErrorKeys.requiredField, {"fieldName": fieldName});
  }

  String get invalidEmail {
    return getString(I18nErrorKeys.invalidEmail);
  }

  String get passwordLength {
    return getString(I18nErrorKeys.passwordLength);
  }

  String get wrongEmailOrPassword {
    return getString(I18nErrorKeys.wrongEmailOrPassword);
  }
}

class I18nFeatureCounterLookup {
  String getString(String key, [Map<String, String>? placeholders]) {
    throw UnimplementedError("I18nFeatureCounterLookup.getString");
  }

  String get counterAppBarTitle {
    return getString(I18nFeatureCounterKeys.counterAppBarTitle);
  }

  String get counterPageTitle {
    return getString(I18nFeatureCounterKeys.counterPageTitle);
  }

  String get increment {
    return getString(I18nFeatureCounterKeys.increment);
  }

  String get decrement {
    return getString(I18nFeatureCounterKeys.decrement);
  }
}

class I18nFeatureLoginLookup {
  String getString(String key, [Map<String, String>? placeholders]) {
    throw UnimplementedError("I18nFeatureLoginLookup.getString");
  }

  String get loginPageTitle {
    return getString(I18nFeatureLoginKeys.loginPageTitle);
  }

  String get logIn {
    return getString(I18nFeatureLoginKeys.logIn);
  }

  String get logOut {
    return getString(I18nFeatureLoginKeys.logOut);
  }

  String get profile {
    return getString(I18nFeatureLoginKeys.profile);
  }

  String get notifications {
    return getString(I18nFeatureLoginKeys.notifications);
  }
}

class I18nFeatureNotificationsLookup {
  String getString(String key, [Map<String, String>? placeholders]) {
    throw UnimplementedError("I18nFeatureNotificationsLookup.getString");
  }

  String get notificationPageTitle {
    return getString(I18nFeatureNotificationsKeys.notificationPageTitle);
  }

  String get notificationsPermissionsDenied {
    return getString(
        I18nFeatureNotificationsKeys.notificationsPermissionsDenied);
  }

  String get notificationPermissionRequestText {
    return getString(
        I18nFeatureNotificationsKeys.notificationPermissionRequestText);
  }

  String get notificationShowText {
    return getString(I18nFeatureNotificationsKeys.notificationShowText);
  }

  String get notificationShowDelayedText {
    return getString(I18nFeatureNotificationsKeys.notificationShowDelayedText);
  }

  String get notificationsPageDescription {
    return getString(I18nFeatureNotificationsKeys.notificationsPageDescription);
  }

  String get notificationsPageConfig {
    return getString(I18nFeatureNotificationsKeys.notificationsPageConfig);
  }
}

class I18nFeatureEnterMessageLookup {
  String getString(String key, [Map<String, String>? placeholders]) {
    throw UnimplementedError("I18nFeatureEnterMessageLookup.getString");
  }

  String get fieldMessageLabel {
    return getString(I18nFeatureEnterMessageKeys.fieldMessageLabel);
  }

  String get fieldHintMessage {
    return getString(I18nFeatureEnterMessageKeys.fieldHintMessage);
  }

  String get pageDescription {
    return getString(I18nFeatureEnterMessageKeys.pageDescription);
  }
}

class I18nFieldLookup {
  String getString(String key, [Map<String, String>? placeholders]) {
    throw UnimplementedError("I18nFieldLookup.getString");
  }

  String get email {
    return getString(I18nFieldKeys.email);
  }

  String get password {
    return getString(I18nFieldKeys.password);
  }
}

class I18nLookup_es extends I18nLookup_en {
  @override
  String get reload {
    return "Reload";
  }

  @override
  String get ok {
    return "OK";
  }

  @override
  String get close {
    return "Close";
  }

  @override
  String get errorState {
    return "Error occurred";
  }

  @override
  String get loadingState {
    return "Loading...";
  }

  @override
  String get resetPassword {
    return "Reset password";
  }

  @override
  String get pageWithResult {
    return "Enter message";
  }

  @override
  String get deepLinkFlowPageTitle {
    return "Deep link flow";
  }

  @override
  String get tryAgain {
    return "Try again";
  }

  @override
  String get confirm {
    return "Confirm";
  }

  @override
  String get submit {
    return "Submit";
  }

  @override
  String get navCounter {
    return "Counter";
  }

  @override
  String get navLinks {
    return "Links";
  }

  @override
  String get navProfile {
    return "Profile";
  }

  @override
  I18nErrorLookup_es createErrorLookup() => I18nErrorLookup_es();

  @override
  I18nFeatureCounterLookup_es createFeatureCounterLookup() =>
      I18nFeatureCounterLookup_es();

  @override
  I18nFeatureLoginLookup_es createFeatureLoginLookup() =>
      I18nFeatureLoginLookup_es();

  @override
  I18nFeatureNotificationsLookup_es createFeatureNotificationsLookup() =>
      I18nFeatureNotificationsLookup_es();

  @override
  I18nFeatureEnterMessageLookup_es createFeatureEnterMessageLookup() =>
      I18nFeatureEnterMessageLookup_es();

  @override
  I18nFieldLookup_es createFieldLookup() => I18nFieldLookup_es();
}

class I18nLookup_en extends I18nLookup {
  @override
  String get reload {
    return "Reload";
  }

  @override
  String get ok {
    return "OK";
  }

  @override
  String get close {
    return "Close";
  }

  @override
  String get errorState {
    return "Error occurred";
  }

  @override
  String get loadingState {
    return "Loading...";
  }

  @override
  String get resetPassword {
    return "Reset password";
  }

  @override
  String get pageWithResult {
    return "Enter message";
  }

  @override
  String get deepLinkFlowPageTitle {
    return "Deep link flow";
  }

  @override
  String get tryAgain {
    return "Try again";
  }

  @override
  String get confirm {
    return "Confirm";
  }

  @override
  String get submit {
    return "Submit";
  }

  @override
  String get navCounter {
    return "Counter";
  }

  @override
  String get navLinks {
    return "Links";
  }

  @override
  String get navProfile {
    return "Profile";
  }

  @override
  I18nErrorLookup_en createErrorLookup() => I18nErrorLookup_en();

  @override
  I18nFeatureCounterLookup_en createFeatureCounterLookup() =>
      I18nFeatureCounterLookup_en();

  @override
  I18nFeatureLoginLookup_en createFeatureLoginLookup() =>
      I18nFeatureLoginLookup_en();

  @override
  I18nFeatureNotificationsLookup_en createFeatureNotificationsLookup() =>
      I18nFeatureNotificationsLookup_en();

  @override
  I18nFeatureEnterMessageLookup_en createFeatureEnterMessageLookup() =>
      I18nFeatureEnterMessageLookup_en();

  @override
  I18nFieldLookup_en createFieldLookup() => I18nFieldLookup_en();
}

class I18nErrorLookup_es extends I18nErrorLookup_en {
  @override
  String get accessDenied {
    return "You don\'t have access to this resource.";
  }

  @override
  String get network {
    return "A network error occurred.";
  }

  @override
  String get noConnection {
    return "It looks like your device is not connected to the internet. Please check your settings.";
  }

  @override
  String get connectionRefused {
    return "Unable to connect to server. Connection refused.";
  }

  @override
  String get notFound {
    return "Resource not found.";
  }

  @override
  String get server {
    return "An error occurred and the request could not be processed. Please try again later.";
  }

  @override
  String get unknown {
    return "Oops, something went wrong. Please try again.";
  }

  @override
  String requiredField(String fieldName) {
    return "${fieldName} should not be empty";
  }

  @override
  String get invalidEmail {
    return "Please enter a valid email";
  }

  @override
  String get passwordLength {
    return "Password should be at least 6 characters long";
  }

  @override
  String get wrongEmailOrPassword {
    return "Wrong email or password";
  }
}

class I18nErrorLookup_en extends I18nErrorLookup {
  @override
  String get accessDenied {
    return "You don\'t have access to this resource.";
  }

  @override
  String get network {
    return "A network error occurred.";
  }

  @override
  String get noConnection {
    return "It looks like your device is not connected to the internet. Please check your settings.";
  }

  @override
  String get connectionRefused {
    return "Unable to connect to server. Connection refused.";
  }

  @override
  String get notFound {
    return "Resource not found.";
  }

  @override
  String get server {
    return "An error occurred and the request could not be processed. Please try again later.";
  }

  @override
  String get unknown {
    return "Oops, something went wrong. Please try again.";
  }

  @override
  String requiredField(String fieldName) {
    return "${fieldName} should not be empty";
  }

  @override
  String get invalidEmail {
    return "Please enter a valid email";
  }

  @override
  String get passwordLength {
    return "Password should be at least 6 characters long";
  }

  @override
  String get wrongEmailOrPassword {
    return "Wrong email or password";
  }
}

class I18nFeatureCounterLookup_es extends I18nFeatureCounterLookup_en {
  @override
  String get counterAppBarTitle {
    return "Counter";
  }

  @override
  String get counterPageTitle {
    return "Counter sample";
  }

  @override
  String get increment {
    return "Increment";
  }

  @override
  String get decrement {
    return "Decrement";
  }
}

class I18nFeatureCounterLookup_en extends I18nFeatureCounterLookup {
  @override
  String get counterAppBarTitle {
    return "Counter";
  }

  @override
  String get counterPageTitle {
    return "Counter sample";
  }

  @override
  String get increment {
    return "Increment";
  }

  @override
  String get decrement {
    return "Decrement";
  }
}

class I18nFeatureLoginLookup_es extends I18nFeatureLoginLookup_en {
  @override
  String get loginPageTitle {
    return "Login sample";
  }

  @override
  String get logIn {
    return "Log in";
  }

  @override
  String get logOut {
    return "Log out";
  }

  @override
  String get profile {
    return "Profile";
  }

  @override
  String get notifications {
    return "Notifications";
  }
}

class I18nFeatureLoginLookup_en extends I18nFeatureLoginLookup {
  @override
  String get loginPageTitle {
    return "Login sample";
  }

  @override
  String get logIn {
    return "Log in";
  }

  @override
  String get logOut {
    return "Log out";
  }

  @override
  String get profile {
    return "Profile";
  }

  @override
  String get notifications {
    return "Notifications";
  }
}

class I18nFeatureNotificationsLookup_es
    extends I18nFeatureNotificationsLookup_en {
  @override
  String get notificationPageTitle {
    return "Notification sample";
  }

  @override
  String get notificationsPermissionsDenied {
    return "Seems that you have denied notifications on this device. In order for us to show notifications, they need to be manually enabled from the device settings.";
  }

  @override
  String get notificationPermissionRequestText {
    return "Request notification permissions";
  }

  @override
  String get notificationShowText {
    return "Show notification";
  }

  @override
  String get notificationShowDelayedText {
    return "Show notification after 5 seconds";
  }

  @override
  String get notificationsPageDescription {
    return "In order to receive push notifications on your device, you need first to grant access to them. This applies for iOS and Web, as the permissions on Android are granted upfront.";
  }

  @override
  String get notificationsPageConfig {
    return "When Firebase Cloud Messaging (FCM) is initialized, a FCM token is generated for the device. You can use this token to receive notifications while the app is in foreground, background or even terminated.";
  }
}

class I18nFeatureNotificationsLookup_en extends I18nFeatureNotificationsLookup {
  @override
  String get notificationPageTitle {
    return "Notification sample";
  }

  @override
  String get notificationsPermissionsDenied {
    return "Seems that you have denied notifications on this device. In order for us to show notifications, they need to be manually enabled from the device settings.";
  }

  @override
  String get notificationPermissionRequestText {
    return "Request notification permissions";
  }

  @override
  String get notificationShowText {
    return "Show notification";
  }

  @override
  String get notificationShowDelayedText {
    return "Show notification after 5 seconds";
  }

  @override
  String get notificationsPageDescription {
    return "In order to receive push notifications on your device, you need first to grant access to them. This applies for iOS and Web, as the permissions on Android are granted upfront.";
  }

  @override
  String get notificationsPageConfig {
    return "When Firebase Cloud Messaging (FCM) is initialized, a FCM token is generated for the device. You can use this token to receive notifications while the app is in foreground, background or even terminated.";
  }
}

class I18nFeatureEnterMessageLookup_es
    extends I18nFeatureEnterMessageLookup_en {
  @override
  String get fieldMessageLabel {
    return "Message";
  }

  @override
  String get fieldHintMessage {
    return "Enter your message";
  }

  @override
  String get pageDescription {
    return "The purpose of this page is to showcase how to return data to the parent page and process it. Enter your message and press the submit button.";
  }
}

class I18nFeatureEnterMessageLookup_en extends I18nFeatureEnterMessageLookup {
  @override
  String get fieldMessageLabel {
    return "Message";
  }

  @override
  String get fieldHintMessage {
    return "Enter your message";
  }

  @override
  String get pageDescription {
    return "The purpose of this page is to showcase how to return data to the parent page and process it. Enter your message and press the submit button.";
  }
}

class I18nFieldLookup_es extends I18nFieldLookup_en {
  @override
  String get email {
    return "Email";
  }

  @override
  String get password {
    return "Password";
  }
}

class I18nFieldLookup_en extends I18nFieldLookup {
  @override
  String get email {
    return "Email";
  }

  @override
  String get password {
    return "Password";
  }
}

class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();

  @override
  Future<I18n> load(Locale locale) {
    I18n._locale = locale;
    return SynchronousFuture<I18n>(I18n(_findLookUpFromLocale(locale)));
  }

  @override
  bool isSupported(Locale locale) => true;

  @override
  bool shouldReload(I18nDelegate old) => false;

  I18nLookup _findLookUpFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case "es":
        return I18nLookup_es();
      case "en":
        return I18nLookup_en();
    }
    return I18nLookup_en();
  }
}

class Fonts {
  static const String workSans = "WorkSans";
}

class Assets {
  /// ![](file:///Users/pavel.georgiev/Projects/rx_bloc/packages/rx_bloc_cli/example/test_app/assets/images/.git_keep)
  static const String gitKeep = "assets/images/.git_keep";
}

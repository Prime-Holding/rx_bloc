import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class I18n {
  final I18nLookup _lookup;

  I18n(this._lookup)
      : error = I18nError(_lookup.createErrorLookup()),
        featureNotifications = I18nFeatureNotifications(_lookup.createFeatureNotificationsLookup()),
        featureProfile = I18nFeatureProfile(_lookup.createFeatureProfileLookup()),
        field = I18nField(_lookup.createFieldLookup()),
        libChangeLanguage = I18nLibChangeLanguage(_lookup.createLibChangeLanguageLookup()),
        libRouter = I18nLibRouter(_lookup.createLibRouterLookup());

  static Locale? _locale;

  static Locale? get currentLocale => _locale;

  /// add custom locale lookup which will be called first
  static I18nLookup? customLookup;

  static const I18nDelegate delegate = I18nDelegate();

  static I18n of(BuildContext context) => Localizations.of<I18n>(context, I18n)!;

  static List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en"),
      Locale("bg")
    ];
  }

  final I18nError error;

  final I18nFeatureNotifications featureNotifications;

  final I18nFeatureProfile featureProfile;

  final I18nField field;

  final I18nLibChangeLanguage libChangeLanguage;

  final I18nLibRouter libRouter;

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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Презареди"</td>
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
  ///     <td>"Dashboard"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Табло за управление"</td>
  ///   </tr>
  ///  </table>
  ///
  String get dashboard {
    return customLookup?.dashboard ?? _lookup.dashboard;
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"добре"</td>
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
  ///     <td>"Open"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Отвори"</td>
  ///   </tr>
  ///  </table>
  ///
  String get open {
    return customLookup?.open ?? _lookup.open;
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Затвори"</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Възникна грешка"</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Зарежда се..."</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Нулиране на парола"</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Въведете съобщение"</td>
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
  ///     <td>"Try again"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Опитайте отново"</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Потвърдете"</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Изпращане"</td>
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
  ///     <td>"Profile"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Профил"</td>
  ///   </tr>
  ///  </table>
  ///
  String get navProfile {
    return customLookup?.navProfile ?? _lookup.navProfile;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"English"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"английски"</td>
  ///   </tr>
  ///  </table>
  ///
  String get english {
    return customLookup?.english ?? _lookup.english;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Bulgarian"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"български"</td>
  ///   </tr>
  ///  </table>
  ///
  String get bulgarian {
    return customLookup?.bulgarian ?? _lookup.bulgarian;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Change Language"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Смени език"</td>
  ///   </tr>
  ///  </table>
  ///
  String get changeLanguage {
    return customLookup?.changeLanguage ?? _lookup.changeLanguage;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Github search"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Github search"</td>
  ///   </tr>
  ///  </table>
  ///
  String get search {
    return customLookup?.search ?? _lookup.search;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Tap on the search icon to search"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Натиснете бутона за търсене за да стартирате търсенето"</td>
  ///   </tr>
  ///  </table>
  ///
  String get searchHint {
    return customLookup?.searchHint ?? _lookup.searchHint;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Selected item {item}"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Избран елемент {item}"</td>
  ///   </tr>
  ///  </table>
  ///
  String selectedItem(String item) {
    return customLookup?.selectedItem(item) ?? _lookup.selectedItem(item);
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nKeys.reload:
        return reload;
      case I18nKeys.dashboard:
        return dashboard;
      case I18nKeys.ok:
        return ok;
      case I18nKeys.open:
        return open;
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
      case I18nKeys.tryAgain:
        return tryAgain;
      case I18nKeys.confirm:
        return confirm;
      case I18nKeys.submit:
        return submit;
      case I18nKeys.navProfile:
        return navProfile;
      case I18nKeys.english:
        return english;
      case I18nKeys.bulgarian:
        return bulgarian;
      case I18nKeys.changeLanguage:
        return changeLanguage;
      case I18nKeys.search:
        return search;
      case I18nKeys.searchHint:
        return searchHint;
      case I18nKeys.selectedItem:
        return selectedItem(placeholders?["item"] ?? "");
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Нямате достъп до този ресурс."</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Възникна мрежова грешка."</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Изглежда, че вашето устройство не е свързано с интернет. Моля, проверете настройките си."</td>
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
  ///     <td>"Unable to connect to server. Connection refused. Check if the local server is up and running then try again."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Не може да се свърже със сървъра. Връзката е отказана. Проверете дали локалният сървър работи и опитайте отново."</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Ресурсът не е намерен."</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Възникна грешка и заявката не можа да бъде обработена. Моля, опитайте отново по-късно."</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Ами сега, нещо се обърка. Моля, опитайте отново."</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"{fieldName} не трябва да е празно"</td>
  ///   </tr>
  ///  </table>
  ///
  String requiredField(String fieldName) {
    return customLookup?.requiredField(fieldName) ?? _lookup.requiredField(fieldName);
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Моля, въведете валиден имейл"</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Паролата трябва да е дълга поне 6 знака"</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Грешен имейл или парола"</td>
  ///   </tr>
  ///  </table>
  ///
  String get wrongEmailOrPassword {
    return customLookup?.wrongEmailOrPassword ?? _lookup.wrongEmailOrPassword;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"The entered message should be at least 2 characters long."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Въведеното съобщение трябва да е дълго поне 2 знака."</td>
  ///   </tr>
  ///  </table>
  ///
  String get invalidMessage {
    return customLookup?.invalidMessage ?? _lookup.invalidMessage;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"The entered text is too long"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Въведеният текст е твърде дълъг"</td>
  ///   </tr>
  ///  </table>
  ///
  String get tooLong {
    return customLookup?.tooLong ?? _lookup.tooLong;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"The entered text is too short"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Въведеният текст е твърде кратък"</td>
  ///   </tr>
  ///  </table>
  ///
  String get tooShort {
    return customLookup?.tooShort ?? _lookup.tooShort;
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Изглежда, че сте отказали известия на това устройство. За да можем да показваме известия, те трябва да бъдат активирани ръчно от настройките на устройството."</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationsDisabledMessage {
    return customLookup?.notificationsDisabledMessage ?? _lookup.notificationsDisabledMessage;
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
      case I18nErrorKeys.invalidMessage:
        return invalidMessage;
      case I18nErrorKeys.tooLong:
        return tooLong;
      case I18nErrorKeys.tooShort:
        return tooShort;
      case I18nErrorKeys.notificationsDisabledMessage:
        return notificationsDisabledMessage;
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Примерно известие"</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Изглежда, че сте отказали известия на това устройство. За да можем да показваме известия, те трябва да бъдат активирани ръчно от настройките на устройството."</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationsPermissionsDenied {
    return customLookup?.notificationsPermissionsDenied ?? _lookup.notificationsPermissionsDenied;
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Искане на разрешения за уведомяване"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationPermissionRequestText {
    return customLookup?.notificationPermissionRequestText ?? _lookup.notificationPermissionRequestText;
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Показване на известие"</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Показване на известие след 5 секунди"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationShowDelayedText {
    return customLookup?.notificationShowDelayedText ?? _lookup.notificationShowDelayedText;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Show redirecting notification"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Показване на известие за пренасочване"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationShowRedirectingText {
    return customLookup?.notificationShowRedirectingText ?? _lookup.notificationShowRedirectingText;
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"За да получавате насочени известия на вашето устройство, първо трябва да предоставите достъп до тях. Това важи за iOS и уеб, тъй като разрешенията за Android се предоставят предварително."</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationsPageDescription {
    return customLookup?.notificationsPageDescription ?? _lookup.notificationsPageDescription;
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Когато Firebase Cloud Messaging (FCM) се инициализира, FCM токен се генерира за устройството. Можете да използвате този токен, за да получавате известия, докато приложението е на преден план, на заден план или дори прекратено."</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationsPageConfig {
    return customLookup?.notificationsPageConfig ?? _lookup.notificationsPageConfig;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"This is a notification!"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Това е нотификация!"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationsMessage {
    return customLookup?.notificationsMessage ?? _lookup.notificationsMessage;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"This is a delayed notification!"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Това е забавена нотификация!"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationsDelayed {
    return customLookup?.notificationsDelayed ?? _lookup.notificationsDelayed;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"This is a redirecting notification"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"This is a redirecting notification"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationRedirecing {
    return customLookup?.notificationRedirecing ?? _lookup.notificationRedirecing;
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
      case I18nFeatureNotificationsKeys.notificationShowRedirectingText:
        return notificationShowRedirectingText;
      case I18nFeatureNotificationsKeys.notificationsPageDescription:
        return notificationsPageDescription;
      case I18nFeatureNotificationsKeys.notificationsPageConfig:
        return notificationsPageConfig;
      case I18nFeatureNotificationsKeys.notificationsMessage:
        return notificationsMessage;
      case I18nFeatureNotificationsKeys.notificationsDelayed:
        return notificationsDelayed;
      case I18nFeatureNotificationsKeys.notificationRedirecing:
        return notificationRedirecing;
    }
    return null;
  }
}

class I18nFeatureProfile {
  I18nFeatureProfile(this._lookup);

  final I18nFeatureProfileLookup _lookup;

  /// add custom locale lookup which will be called first
  static I18nFeatureProfileLookup? customLookup;

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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Примерно известие"</td>
  ///   </tr>
  ///  </table>
  ///
  String get profilePageNotificationsButton {
    return customLookup?.profilePageNotificationsButton ?? _lookup.profilePageNotificationsButton;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Change Languge"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Смени език"</td>
  ///   </tr>
  ///  </table>
  ///
  String get profilePageChangeLanguageButton {
    return customLookup?.profilePageChangeLanguageButton ?? _lookup.profilePageChangeLanguageButton;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Enable notification"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Aктивиране на известяване"</td>
  ///   </tr>
  ///  </table>
  ///
  String get profilePageEnableNotificationText {
    return customLookup?.profilePageEnableNotificationText ?? _lookup.profilePageEnableNotificationText;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Notifications enabled successfully"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Известията са активирани успешно"</td>
  ///   </tr>
  ///  </table>
  ///
  String get enableNotificationSuccessMessage {
    return customLookup?.enableNotificationSuccessMessage ?? _lookup.enableNotificationSuccessMessage;
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Изглежда, че сте отказали известия на това устройство. За да можем да показваме известия, те трябва да бъдат активирани ръчно от настройките на устройството."</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationsDisabledMessage {
    return customLookup?.notificationsDisabledMessage ?? _lookup.notificationsDisabledMessage;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Your Notifications were turned on successfully!"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Нотификациите ви са успешно Включени!"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationsTurnedOn {
    return customLookup?.notificationsTurnedOn ?? _lookup.notificationsTurnedOn;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Your Notifications were turned off successfully!"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Нотификациите ви са успешно изключени!"</td>
  ///   </tr>
  ///  </table>
  ///
  String get notificationsTurnedOff {
    return customLookup?.notificationsTurnedOff ?? _lookup.notificationsTurnedOff;
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nFeatureProfileKeys.profilePageNotificationsButton:
        return profilePageNotificationsButton;
      case I18nFeatureProfileKeys.profilePageChangeLanguageButton:
        return profilePageChangeLanguageButton;
      case I18nFeatureProfileKeys.profilePageEnableNotificationText:
        return profilePageEnableNotificationText;
      case I18nFeatureProfileKeys.enableNotificationSuccessMessage:
        return enableNotificationSuccessMessage;
      case I18nFeatureProfileKeys.notificationsDisabledMessage:
        return notificationsDisabledMessage;
      case I18nFeatureProfileKeys.notificationsTurnedOn:
        return notificationsTurnedOn;
      case I18nFeatureProfileKeys.notificationsTurnedOff:
        return notificationsTurnedOff;
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Имейл"</td>
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
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Парола"</td>
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

class I18nLibChangeLanguage {
  I18nLibChangeLanguage(this._lookup);

  final I18nLibChangeLanguageLookup _lookup;

  /// add custom locale lookup which will be called first
  static I18nLibChangeLanguageLookup? customLookup;

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Bulgarian"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"български"</td>
  ///   </tr>
  ///  </table>
  ///
  String get bulgarian {
    return customLookup?.bulgarian ?? _lookup.bulgarian;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"English"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"английски"</td>
  ///   </tr>
  ///  </table>
  ///
  String get english {
    return customLookup?.english ?? _lookup.english;
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nLibChangeLanguageKeys.bulgarian:
        return bulgarian;
      case I18nLibChangeLanguageKeys.english:
        return english;
    }
    return null;
  }
}

class I18nLibRouter {
  I18nLibRouter(this._lookup);

  final I18nLibRouterLookup _lookup;

  /// add custom locale lookup which will be called first
  static I18nLibRouterLookup? customLookup;

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Error page!"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Страница с грешка!"</td>
  ///   </tr>
  ///  </table>
  ///
  String get appBarText {
    return customLookup?.appBarText ?? _lookup.appBarText;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"An error occurred."</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Появи се грешка"</td>
  ///   </tr>
  ///  </table>
  ///
  String get errorOccurred {
    return customLookup?.errorOccurred ?? _lookup.errorOccurred;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"Error: {theError}"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">bg</td>
  ///     <td>"Грешка: {theError}"</td>
  ///   </tr>
  ///  </table>
  ///
  String error(String theError) {
    return customLookup?.error(theError) ?? _lookup.error(theError);
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nLibRouterKeys.appBarText:
        return appBarText;
      case I18nLibRouterKeys.errorOccurred:
        return errorOccurred;
      case I18nLibRouterKeys.error:
        return error(placeholders?["theError"] ?? "");
    }
    return null;
  }
}

class I18nKeys {
  static const String reload = "reload";
  static const String dashboard = "dashboard";
  static const String ok = "ok";
  static const String open = "open";
  static const String close = "close";
  static const String errorState = "errorState";
  static const String loadingState = "loadingState";
  static const String resetPassword = "resetPassword";
  static const String pageWithResult = "pageWithResult";
  static const String tryAgain = "tryAgain";
  static const String confirm = "confirm";
  static const String submit = "submit";
  static const String navProfile = "navProfile";
  static const String english = "english";
  static const String bulgarian = "bulgarian";
  static const String changeLanguage = "changeLanguage";
  static const String search = "search";
  static const String searchHint = "searchHint";
  static const String selectedItem = "selectedItem";
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
  static const String invalidMessage = "invalidMessage";
  static const String tooLong = "tooLong";
  static const String tooShort = "tooShort";
  static const String notificationsDisabledMessage = "notificationsDisabledMessage";
}

class I18nFeatureNotificationsKeys {
  static const String notificationPageTitle = "notificationPageTitle";
  static const String notificationsPermissionsDenied = "notificationsPermissionsDenied";
  static const String notificationPermissionRequestText = "notificationPermissionRequestText";
  static const String notificationShowText = "notificationShowText";
  static const String notificationShowDelayedText = "notificationShowDelayedText";
  static const String notificationShowRedirectingText = "notificationShowRedirectingText";
  static const String notificationsPageDescription = "notificationsPageDescription";
  static const String notificationsPageConfig = "notificationsPageConfig";
  static const String notificationsMessage = "notificationsMessage";
  static const String notificationsDelayed = "notificationsDelayed";
  static const String notificationRedirecing = "notificationRedirecing";
}

class I18nFeatureProfileKeys {
  static const String profilePageNotificationsButton = "profilePageNotificationsButton";
  static const String profilePageChangeLanguageButton = "profilePageChangeLanguageButton";
  static const String profilePageEnableNotificationText = "profilePageEnableNotificationText";
  static const String enableNotificationSuccessMessage = "enableNotificationSuccessMessage";
  static const String notificationsDisabledMessage = "notificationsDisabledMessage";
  static const String notificationsTurnedOn = "notificationsTurnedOn";
  static const String notificationsTurnedOff = "notificationsTurnedOff";
}

class I18nFieldKeys {
  static const String email = "email";
  static const String password = "password";
}

class I18nLibChangeLanguageKeys {
  static const String bulgarian = "bulgarian";
  static const String english = "english";
}

class I18nLibRouterKeys {
  static const String appBarText = "appBarText";
  static const String errorOccurred = "errorOccurred";
  static const String error = "error";
}

class I18nLookup {
  String getString(String key, [Map<String, String>? placeholders]) {
    throw UnimplementedError("I18nLookup.getString");
  }

  String get reload {
    return getString(I18nKeys.reload);
  }

  String get dashboard {
    return getString(I18nKeys.dashboard);
  }

  String get ok {
    return getString(I18nKeys.ok);
  }

  String get open {
    return getString(I18nKeys.open);
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

  String get tryAgain {
    return getString(I18nKeys.tryAgain);
  }

  String get confirm {
    return getString(I18nKeys.confirm);
  }

  String get submit {
    return getString(I18nKeys.submit);
  }

  String get navProfile {
    return getString(I18nKeys.navProfile);
  }

  String get english {
    return getString(I18nKeys.english);
  }

  String get bulgarian {
    return getString(I18nKeys.bulgarian);
  }

  String get changeLanguage {
    return getString(I18nKeys.changeLanguage);
  }

  String get search {
    return getString(I18nKeys.search);
  }

  String get searchHint {
    return getString(I18nKeys.searchHint);
  }

  String selectedItem(String item) {
    return getString(I18nKeys.selectedItem, {"item": item});
  }

  I18nErrorLookup createErrorLookup() => I18nErrorLookup();

  I18nFeatureNotificationsLookup createFeatureNotificationsLookup() => I18nFeatureNotificationsLookup();

  I18nFeatureProfileLookup createFeatureProfileLookup() => I18nFeatureProfileLookup();

  I18nFieldLookup createFieldLookup() => I18nFieldLookup();

  I18nLibChangeLanguageLookup createLibChangeLanguageLookup() => I18nLibChangeLanguageLookup();

  I18nLibRouterLookup createLibRouterLookup() => I18nLibRouterLookup();
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

  String get invalidMessage {
    return getString(I18nErrorKeys.invalidMessage);
  }

  String get tooLong {
    return getString(I18nErrorKeys.tooLong);
  }

  String get tooShort {
    return getString(I18nErrorKeys.tooShort);
  }

  String get notificationsDisabledMessage {
    return getString(I18nErrorKeys.notificationsDisabledMessage);
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
    return getString(I18nFeatureNotificationsKeys.notificationsPermissionsDenied);
  }

  String get notificationPermissionRequestText {
    return getString(I18nFeatureNotificationsKeys.notificationPermissionRequestText);
  }

  String get notificationShowText {
    return getString(I18nFeatureNotificationsKeys.notificationShowText);
  }

  String get notificationShowDelayedText {
    return getString(I18nFeatureNotificationsKeys.notificationShowDelayedText);
  }

  String get notificationShowRedirectingText {
    return getString(I18nFeatureNotificationsKeys.notificationShowRedirectingText);
  }

  String get notificationsPageDescription {
    return getString(I18nFeatureNotificationsKeys.notificationsPageDescription);
  }

  String get notificationsPageConfig {
    return getString(I18nFeatureNotificationsKeys.notificationsPageConfig);
  }

  String get notificationsMessage {
    return getString(I18nFeatureNotificationsKeys.notificationsMessage);
  }

  String get notificationsDelayed {
    return getString(I18nFeatureNotificationsKeys.notificationsDelayed);
  }

  String get notificationRedirecing {
    return getString(I18nFeatureNotificationsKeys.notificationRedirecing);
  }
}

class I18nFeatureProfileLookup {
  String getString(String key, [Map<String, String>? placeholders]) {
    throw UnimplementedError("I18nFeatureProfileLookup.getString");
  }

  String get profilePageNotificationsButton {
    return getString(I18nFeatureProfileKeys.profilePageNotificationsButton);
  }

  String get profilePageChangeLanguageButton {
    return getString(I18nFeatureProfileKeys.profilePageChangeLanguageButton);
  }

  String get profilePageEnableNotificationText {
    return getString(I18nFeatureProfileKeys.profilePageEnableNotificationText);
  }

  String get enableNotificationSuccessMessage {
    return getString(I18nFeatureProfileKeys.enableNotificationSuccessMessage);
  }

  String get notificationsDisabledMessage {
    return getString(I18nFeatureProfileKeys.notificationsDisabledMessage);
  }

  String get notificationsTurnedOn {
    return getString(I18nFeatureProfileKeys.notificationsTurnedOn);
  }

  String get notificationsTurnedOff {
    return getString(I18nFeatureProfileKeys.notificationsTurnedOff);
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

class I18nLibChangeLanguageLookup {
  String getString(String key, [Map<String, String>? placeholders]) {
    throw UnimplementedError("I18nLibChangeLanguageLookup.getString");
  }

  String get bulgarian {
    return getString(I18nLibChangeLanguageKeys.bulgarian);
  }

  String get english {
    return getString(I18nLibChangeLanguageKeys.english);
  }
}

class I18nLibRouterLookup {
  String getString(String key, [Map<String, String>? placeholders]) {
    throw UnimplementedError("I18nLibRouterLookup.getString");
  }

  String get appBarText {
    return getString(I18nLibRouterKeys.appBarText);
  }

  String get errorOccurred {
    return getString(I18nLibRouterKeys.errorOccurred);
  }

  String error(String theError) {
    return getString(I18nLibRouterKeys.error, {"theError": theError});
  }
}

class I18nLookup_bg extends I18nLookup_en {
  @override
  String get reload {
    return "Презареди";
  }

  @override
  String get dashboard {
    return "Табло за управление";
  }

  @override
  String get ok {
    return "добре";
  }

  @override
  String get open {
    return "Отвори";
  }

  @override
  String get close {
    return "Затвори";
  }

  @override
  String get errorState {
    return "Възникна грешка";
  }

  @override
  String get loadingState {
    return "Зарежда се...";
  }

  @override
  String get resetPassword {
    return "Нулиране на парола";
  }

  @override
  String get pageWithResult {
    return "Въведете съобщение";
  }

  @override
  String get tryAgain {
    return "Опитайте отново";
  }

  @override
  String get confirm {
    return "Потвърдете";
  }

  @override
  String get submit {
    return "Изпращане";
  }

  @override
  String get navProfile {
    return "Профил";
  }

  @override
  String get english {
    return "английски";
  }

  @override
  String get bulgarian {
    return "български";
  }

  @override
  String get changeLanguage {
    return "Смени език";
  }

  @override
  String get search {
    return "Github search";
  }

  @override
  String get searchHint {
    return "Натиснете бутона за търсене за да стартирате търсенето";
  }

  @override
  String selectedItem(String item) {
    return "Избран елемент ${item}";
  }

  @override
  I18nErrorLookup_bg createErrorLookup() => I18nErrorLookup_bg();

  @override
  I18nFeatureNotificationsLookup_bg createFeatureNotificationsLookup() => I18nFeatureNotificationsLookup_bg();

  @override
  I18nFeatureProfileLookup_bg createFeatureProfileLookup() => I18nFeatureProfileLookup_bg();

  @override
  I18nFieldLookup_bg createFieldLookup() => I18nFieldLookup_bg();

  @override
  I18nLibChangeLanguageLookup_bg createLibChangeLanguageLookup() => I18nLibChangeLanguageLookup_bg();

  @override
  I18nLibRouterLookup_bg createLibRouterLookup() => I18nLibRouterLookup_bg();
}

class I18nLookup_en extends I18nLookup {
  @override
  String get reload {
    return "Reload";
  }

  @override
  String get dashboard {
    return "Dashboard";
  }

  @override
  String get ok {
    return "OK";
  }

  @override
  String get open {
    return "Open";
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
  String get navProfile {
    return "Profile";
  }

  @override
  String get english {
    return "English";
  }

  @override
  String get bulgarian {
    return "Bulgarian";
  }

  @override
  String get changeLanguage {
    return "Change Language";
  }

  @override
  String get search {
    return "Github search";
  }

  @override
  String get searchHint {
    return "Tap on the search icon to search";
  }

  @override
  String selectedItem(String item) {
    return "Selected item ${item}";
  }

  @override
  I18nErrorLookup_en createErrorLookup() => I18nErrorLookup_en();

  @override
  I18nFeatureNotificationsLookup_en createFeatureNotificationsLookup() => I18nFeatureNotificationsLookup_en();

  @override
  I18nFeatureProfileLookup_en createFeatureProfileLookup() => I18nFeatureProfileLookup_en();

  @override
  I18nFieldLookup_en createFieldLookup() => I18nFieldLookup_en();

  @override
  I18nLibChangeLanguageLookup_en createLibChangeLanguageLookup() => I18nLibChangeLanguageLookup_en();

  @override
  I18nLibRouterLookup_en createLibRouterLookup() => I18nLibRouterLookup_en();
}

class I18nErrorLookup_bg extends I18nErrorLookup_en {
  @override
  String get accessDenied {
    return "Нямате достъп до този ресурс.";
  }

  @override
  String get network {
    return "Възникна мрежова грешка.";
  }

  @override
  String get noConnection {
    return "Изглежда, че вашето устройство не е свързано с интернет. Моля, проверете настройките си.";
  }

  @override
  String get connectionRefused {
    return "Не може да се свърже със сървъра. Връзката е отказана. Проверете дали локалният сървър работи и опитайте отново.";
  }

  @override
  String get notFound {
    return "Ресурсът не е намерен.";
  }

  @override
  String get server {
    return "Възникна грешка и заявката не можа да бъде обработена. Моля, опитайте отново по-късно.";
  }

  @override
  String get unknown {
    return "Ами сега, нещо се обърка. Моля, опитайте отново.";
  }

  @override
  String requiredField(String fieldName) {
    return "${fieldName} не трябва да е празно";
  }

  @override
  String get invalidEmail {
    return "Моля, въведете валиден имейл";
  }

  @override
  String get passwordLength {
    return "Паролата трябва да е дълга поне 6 знака";
  }

  @override
  String get wrongEmailOrPassword {
    return "Грешен имейл или парола";
  }

  @override
  String get invalidMessage {
    return "Въведеното съобщение трябва да е дълго поне 2 знака.";
  }

  @override
  String get tooLong {
    return "Въведеният текст е твърде дълъг";
  }

  @override
  String get tooShort {
    return "Въведеният текст е твърде кратък";
  }

  @override
  String get notificationsDisabledMessage {
    return "Изглежда, че сте отказали известия на това устройство. За да можем да показваме известия, те трябва да бъдат активирани ръчно от настройките на устройството.";
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
    return "Unable to connect to server. Connection refused. Check if the local server is up and running then try again.";
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

  @override
  String get invalidMessage {
    return "The entered message should be at least 2 characters long.";
  }

  @override
  String get tooLong {
    return "The entered text is too long";
  }

  @override
  String get tooShort {
    return "The entered text is too short";
  }

  @override
  String get notificationsDisabledMessage {
    return "Seems that you have denied notifications on this device. In order for us to show notifications, they need to be manually enabled from the device settings.";
  }
}

class I18nFeatureNotificationsLookup_bg extends I18nFeatureNotificationsLookup_en {
  @override
  String get notificationPageTitle {
    return "Примерно известие";
  }

  @override
  String get notificationsPermissionsDenied {
    return "Изглежда, че сте отказали известия на това устройство. За да можем да показваме известия, те трябва да бъдат активирани ръчно от настройките на устройството.";
  }

  @override
  String get notificationPermissionRequestText {
    return "Искане на разрешения за уведомяване";
  }

  @override
  String get notificationShowText {
    return "Показване на известие";
  }

  @override
  String get notificationShowDelayedText {
    return "Показване на известие след 5 секунди";
  }

  @override
  String get notificationShowRedirectingText {
    return "Показване на известие за пренасочване";
  }

  @override
  String get notificationsPageDescription {
    return "За да получавате насочени известия на вашето устройство, първо трябва да предоставите достъп до тях. Това важи за iOS и уеб, тъй като разрешенията за Android се предоставят предварително.";
  }

  @override
  String get notificationsPageConfig {
    return "Когато Firebase Cloud Messaging (FCM) се инициализира, FCM токен се генерира за устройството. Можете да използвате този токен, за да получавате известия, докато приложението е на преден план, на заден план или дори прекратено.";
  }

  @override
  String get notificationsMessage {
    return "Това е нотификация!";
  }

  @override
  String get notificationsDelayed {
    return "Това е забавена нотификация!";
  }

  @override
  String get notificationRedirecing {
    return "This is a redirecting notification";
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
  String get notificationShowRedirectingText {
    return "Show redirecting notification";
  }

  @override
  String get notificationsPageDescription {
    return "In order to receive push notifications on your device, you need first to grant access to them. This applies for iOS and Web, as the permissions on Android are granted upfront.";
  }

  @override
  String get notificationsPageConfig {
    return "When Firebase Cloud Messaging (FCM) is initialized, a FCM token is generated for the device. You can use this token to receive notifications while the app is in foreground, background or even terminated.";
  }

  @override
  String get notificationsMessage {
    return "This is a notification!";
  }

  @override
  String get notificationsDelayed {
    return "This is a delayed notification!";
  }

  @override
  String get notificationRedirecing {
    return "This is a redirecting notification";
  }
}

class I18nFeatureProfileLookup_bg extends I18nFeatureProfileLookup_en {
  @override
  String get profilePageNotificationsButton {
    return "Примерно известие";
  }

  @override
  String get profilePageChangeLanguageButton {
    return "Смени език";
  }

  @override
  String get profilePageEnableNotificationText {
    return "Aктивиране на известяване";
  }

  @override
  String get enableNotificationSuccessMessage {
    return "Известията са активирани успешно";
  }

  @override
  String get notificationsDisabledMessage {
    return "Изглежда, че сте отказали известия на това устройство. За да можем да показваме известия, те трябва да бъдат активирани ръчно от настройките на устройството.";
  }

  @override
  String get notificationsTurnedOn {
    return "Нотификациите ви са успешно Включени!";
  }

  @override
  String get notificationsTurnedOff {
    return "Нотификациите ви са успешно изключени!";
  }
}

class I18nFeatureProfileLookup_en extends I18nFeatureProfileLookup {
  @override
  String get profilePageNotificationsButton {
    return "Notification sample";
  }

  @override
  String get profilePageChangeLanguageButton {
    return "Change Languge";
  }

  @override
  String get profilePageEnableNotificationText {
    return "Enable notification";
  }

  @override
  String get enableNotificationSuccessMessage {
    return "Notifications enabled successfully";
  }

  @override
  String get notificationsDisabledMessage {
    return "Seems that you have denied notifications on this device. In order for us to show notifications, they need to be manually enabled from the device settings.";
  }

  @override
  String get notificationsTurnedOn {
    return "Your Notifications were turned on successfully!";
  }

  @override
  String get notificationsTurnedOff {
    return "Your Notifications were turned off successfully!";
  }
}

class I18nFieldLookup_bg extends I18nFieldLookup_en {
  @override
  String get email {
    return "Имейл";
  }

  @override
  String get password {
    return "Парола";
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

class I18nLibChangeLanguageLookup_bg extends I18nLibChangeLanguageLookup_en {
  @override
  String get bulgarian {
    return "български";
  }

  @override
  String get english {
    return "английски";
  }
}

class I18nLibChangeLanguageLookup_en extends I18nLibChangeLanguageLookup {
  @override
  String get bulgarian {
    return "Bulgarian";
  }

  @override
  String get english {
    return "English";
  }
}

class I18nLibRouterLookup_bg extends I18nLibRouterLookup_en {
  @override
  String get appBarText {
    return "Страница с грешка!";
  }

  @override
  String get errorOccurred {
    return "Появи се грешка";
  }

  @override
  String error(String theError) {
    return "Грешка: ${theError}";
  }
}

class I18nLibRouterLookup_en extends I18nLibRouterLookup {
  @override
  String get appBarText {
    return "Error page!";
  }

  @override
  String get errorOccurred {
    return "An error occurred.";
  }

  @override
  String error(String theError) {
    return "Error: ${theError}";
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
        case "bg":
          return I18nLookup_bg();
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
  /// ![](file:///Users/pwndp/repos/rx_bloc/examples/github_search/assets/images/.git_keep)
  static const String gitKeep = "assets/images/.git_keep";
}


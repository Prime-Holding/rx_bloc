/// Enum representing different time formats with each one including the smaller
/// time formats.
enum CountdownTimeFormat {
  /// Displays the countdown as seconds
  seconds,

  /// Displays the countdown in the minutes:seconds format
  minutes,

  /// Displays the countdown in the hours:minutes:seconds format
  hours,
}

/// The method that is used to get the sms code on Android
enum AndroidSmsAutofillMethod {
  /// Disabled SMS autofill on Android
  none,

  /// Automatically reads sms without user interaction
  /// Requires SMS to contain The App signature, see readme for more details
  /// More about Sms Retriever API https://developers.google.com/identity/sms-retriever/overview?hl=en
  smsRetrieverApi,

  /// Requires user interaction to confirm reading a SMS, see readme for more details
  /// [AndroidSmsAutofillMethod.smsUserConsentApi]
  /// More about SMS User Consent API https://developers.google.com/identity/sms-retriever/user-consent/overview
  smsUserConsentApi,
}

/// The animation type if Pin item
enum PinAnimationType {
  none,
  scale,
  fade,
  slide,
  rotation,
}

/// The vibration type when user types
enum HapticFeedbackType {
  disabled,
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
}

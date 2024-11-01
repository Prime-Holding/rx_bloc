/// Showcase Configuration
class ShowcaseConfiguration {
  /// ShowcaseConfiguration constructor
  ShowcaseConfiguration({
    required this.counterEnabled,
    required this.widgetToolkitEnabled,
    required this.qrScannerEnabled,
    required this.deepLinkEnabled,
    required this.mfaEnabled,
    required this.otpEnabled,
  });

  /// Counter showcase enabled
  final bool counterEnabled;

  /// Widget Toolkit showcase enabled
  final bool widgetToolkitEnabled;

  /// QrScanner showcase enabled
  final bool qrScannerEnabled;

  /// Deep links showcase enabled
  final bool deepLinkEnabled;

  /// Multi-Factor Authentication showcase enabled
  final bool mfaEnabled;

  /// OTP showcase enabled
  final bool otpEnabled;

  /// Showcase enabled
  bool get showcaseEnabled =>
      counterEnabled ||
      widgetToolkitEnabled ||
      qrScannerEnabled ||
      deepLinkEnabled ||
      mfaEnabled ||
      otpEnabled;
}

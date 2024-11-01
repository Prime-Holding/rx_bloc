import 'package:rx_bloc_cli/src/models/configurations/showcase_configuration.dart';
import 'package:test/test.dart';

void main() {
  late ShowcaseConfiguration sut;

  group('test showcase_configuration', () {
    test(
        'should have showcase enabled if '
        'any of the showcase features is enabled', () {
      sut = ShowcaseConfiguration(
        counterEnabled: true,
        widgetToolkitEnabled: false,
        deepLinkEnabled: false,
        qrScannerEnabled: false,
        mfaEnabled: false,
        otpEnabled: false,
      );

      expect(sut.showcaseEnabled, isTrue);
      sut = ShowcaseConfiguration(
        counterEnabled: false,
        widgetToolkitEnabled: true,
        deepLinkEnabled: false,
        qrScannerEnabled: false,
        mfaEnabled: false,
        otpEnabled: false,
      );
      expect(sut.showcaseEnabled, isTrue);

      sut = ShowcaseConfiguration(
        counterEnabled: false,
        widgetToolkitEnabled: false,
        deepLinkEnabled: true,
        qrScannerEnabled: false,
        mfaEnabled: false,
        otpEnabled: false,
      );
      expect(sut.showcaseEnabled, isTrue);
      sut = ShowcaseConfiguration(
        counterEnabled: false,
        widgetToolkitEnabled: false,
        deepLinkEnabled: false,
        qrScannerEnabled: true,
        mfaEnabled: false,
        otpEnabled: false,
      );
      expect(sut.showcaseEnabled, isTrue);

      sut = ShowcaseConfiguration(
        counterEnabled: false,
        widgetToolkitEnabled: false,
        deepLinkEnabled: false,
        qrScannerEnabled: false,
        mfaEnabled: true,
        otpEnabled: false,
      );
      expect(sut.showcaseEnabled, isTrue);

      sut = ShowcaseConfiguration(
        counterEnabled: false,
        widgetToolkitEnabled: false,
        deepLinkEnabled: false,
        qrScannerEnabled: false,
        mfaEnabled: false,
        otpEnabled: true,
      );
      expect(sut.showcaseEnabled, isTrue);

      sut = ShowcaseConfiguration(
        counterEnabled: false,
        widgetToolkitEnabled: false,
        deepLinkEnabled: false,
        qrScannerEnabled: false,
        mfaEnabled: false,
        otpEnabled: false,
      );
      expect(sut.showcaseEnabled, isFalse);
    });
  });
}

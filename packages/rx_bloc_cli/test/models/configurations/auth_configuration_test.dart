import 'package:rx_bloc_cli/src/models/configurations/auth_configuration.dart';
import 'package:test/test.dart';

void main() {
  late AuthConfiguration sut;

  group('test auth_configuration', () {
    test('should have authentication enabled if any property is enabled', () {
      sut = AuthConfiguration(
        loginEnabled: true,
        socialLoginsEnabled: false,
        otpEnabled: false,
        pinCodeEnabled: false,
      );
      expect(sut.authenticationEnabled, isTrue);

      sut = AuthConfiguration(
        loginEnabled: false,
        socialLoginsEnabled: true,
        otpEnabled: false,
        pinCodeEnabled: false,
      );
      expect(sut.authenticationEnabled, isTrue);

      sut = AuthConfiguration(
        loginEnabled: false,
        socialLoginsEnabled: false,
        otpEnabled: true,
        pinCodeEnabled: false,
      );
      expect(sut.authenticationEnabled, isTrue);

      sut = AuthConfiguration(
        loginEnabled: false,
        socialLoginsEnabled: false,
        otpEnabled: false,
        pinCodeEnabled: true,
      );
      expect(sut.authenticationEnabled, isTrue);

      sut = AuthConfiguration(
        loginEnabled: false,
        socialLoginsEnabled: false,
        otpEnabled: false,
        pinCodeEnabled: false,
      );
      expect(sut.authenticationEnabled, isFalse);
    });
  });
}

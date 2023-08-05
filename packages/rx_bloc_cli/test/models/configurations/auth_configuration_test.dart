import 'package:rx_bloc_cli/src/models/configurations/auth_configuration.dart';
import 'package:test/test.dart';

void main() {
  late AuthConfiguration sut;

  group('test auth_configuration', () {
    test('should have authentication enabled if anything else is enabled', () {
      sut = AuthConfiguration(
        loginEnabled: true,
        socialLoginsEnabled: false,
        otpEnabled: false,
      );
      expect(sut.authenticationEnabled, isTrue);

      sut = AuthConfiguration(
        loginEnabled: false,
        socialLoginsEnabled: true,
        otpEnabled: false,
      );
      expect(sut.authenticationEnabled, isTrue);

      sut = AuthConfiguration(
        loginEnabled: false,
        socialLoginsEnabled: false,
        otpEnabled: true,
      );
      expect(sut.authenticationEnabled, isTrue);

      sut = AuthConfiguration(
        loginEnabled: false,
        socialLoginsEnabled: false,
        otpEnabled: false,
      );
      expect(sut.authenticationEnabled, isFalse);
    });
  });
}

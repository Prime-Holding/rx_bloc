import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/lib_auth/repositories/auth_repository.dart';
import 'package:{{project_name}}/lib_auth/services/auth_service.dart';

import '../stubs.dart';
import 'auth_service_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepository;
  late AuthService authService;

  setUp(() {
    mockRepository = MockAuthRepository();
    authService = AuthService(mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
  });

  group('AuthService', () {
    test('getToken should return token', () async {
      const token = Stubs.authToken;
      when(mockRepository.getToken()).thenAnswer((_) async => token);

      final result = await authService.getToken();

      expect(result, token);
      verify(mockRepository.getToken()).called(1);
    });

    test('isAuthenticated should return true', () async {
      when(mockRepository.getToken()).thenAnswer((_) async => Stubs.authToken);

      final result = await authService.isAuthenticated();

      expect(result, true);
      verify(mockRepository.getToken()).called(1);
    });

    test('saveToken should call repository saveToken', () async {
      const token = Stubs.authToken;

      await authService.saveToken(token);

      verify(mockRepository.saveToken(token)).called(1);
    });

    test('getRefreshToken should return token', () async {
      const refreshToken = Stubs.refreshToken;
      when(mockRepository.getRefreshToken())
          .thenAnswer((_) async => refreshToken);

      final result = await authService.getRefreshToken();

      expect(result, refreshToken);
      verify(mockRepository.getRefreshToken()).called(1);
    });

    test('fetchNewToken should return AuthTokenModel', () async {
      final authTokenModel = Stubs.authTokenModel;
      final refreshToken = authTokenModel.refreshToken;

      when(mockRepository.getRefreshToken())
          .thenAnswer((_) async => refreshToken);

      when(mockRepository.fetchNewToken(refreshToken))
          .thenAnswer((_) async => authTokenModel);

      final result = await authService.fetchNewToken();

      expect(result, authTokenModel);
      verify(mockRepository.getRefreshToken()).called(1);
      verify(mockRepository.fetchNewToken(refreshToken)).called(1);
    });

    test('authenticate should return AuthTokenModel', () async {
      final userWithAuthTokenModel = Stubs.userWithAuthTokenModel;
      final refreshToken = userWithAuthTokenModel.authToken.refreshToken;

      when(mockRepository.authenticate(
              email: Stubs.email,
              password: Stubs.password,
              refreshToken: refreshToken))
          .thenAnswer((_) async => Stubs.userWithAuthTokenModel);

      final result = await authService.authenticate(
          email: Stubs.email,
          password: Stubs.password,
          refreshToken: refreshToken);

      expect(result, userWithAuthTokenModel);
      verify(mockRepository.authenticate(
              email: Stubs.email,
              password: Stubs.password,
              refreshToken: refreshToken))
          .called(1);
    });

    test('logout should call repository logout', () async {
      await authService.logout();

      verify(mockRepository.logout()).called(1);
    });
  });
}

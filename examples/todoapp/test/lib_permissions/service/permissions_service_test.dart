import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/lib_permissions/repositories/permissions_repository.dart';
import 'package:todoapp/lib_permissions/services/permissions_service.dart';

import 'permissions_service_test.mocks.dart';

@GenerateMocks([PermissionsRepository])
void main() {
  late PermissionsService permissionsService;
  late MockPermissionsRepository mockPermissionsRepository;

  setUp(() {
    mockPermissionsRepository = MockPermissionsRepository();
    permissionsService = PermissionsService(mockPermissionsRepository);
  });

  group('PermissionsService', () {
    test(
        'checkPermission should throw AccessDeniedErrorModel if permission is denied',
        () async {
      when(mockPermissionsRepository.getPermissions())
          .thenAnswer((_) async => {'test_key': false});

      expect(() => permissionsService.checkPermission('test_key'),
          throwsA(isA<AccessDeniedErrorModel>()));
    });

    test('checkPermission should not throw if permission is granted', () async {
      when(mockPermissionsRepository.getPermissions())
          .thenAnswer((_) async => {'test_key': true});

      expect(() => permissionsService.checkPermission('test_key'),
          returnsNormally);
    });

    test('hasPermission should return true if permission is granted', () async {
      when(mockPermissionsRepository.getPermissions())
          .thenAnswer((_) async => {'test_key': true});

      final result = await permissionsService.hasPermission('test_key');
      expect(result, true);
    });

    test('hasPermission should return false if permission is denied', () async {
      when(mockPermissionsRepository.getPermissions())
          .thenAnswer((_) async => {'test_key': false});

      final result = await permissionsService.hasPermission('test_key');
      expect(result, false);
    });

    test(
        'hasPermission should return true if permission list cannot be fetched and graceful is true',
        () async {
      when(mockPermissionsRepository.getPermissions()).thenThrow(Exception());

      final result =
          await permissionsService.hasPermission('test_key', graceful: true);
      expect(result, true);
    });

    test(
        'getPermissions should fetch permissions from repository if cache is empty',
        () async {
      when(mockPermissionsRepository.getPermissions())
          .thenAnswer((_) async => {'test_key': true});

      final result = await permissionsService.getPermissions();
      expect(result, {'test_key': true});
    });

    test(
        'getPermissions should fetch permissions from repository if force is true',
        () async {
      when(mockPermissionsRepository.getPermissions())
          .thenAnswer((_) async => {'test_key': true});

      final result = await permissionsService.getPermissions(force: true);
      expect(result, {'test_key': true});
    });
  });
}

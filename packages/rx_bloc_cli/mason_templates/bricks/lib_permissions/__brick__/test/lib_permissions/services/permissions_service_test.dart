import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/lib_permissions/repositories/permissions_repository.dart';
import 'package:{{project_name}}/lib_permissions/services/permissions_service.dart';

import '../stubs.dart';
import 'permissions_service_test.mocks.dart';

@GenerateMocks([PermissionsRepository])
void main() {
  late MockPermissionsRepository repository;
  late PermissionsService permissionsService;

  setUp(() {
    repository = MockPermissionsRepository();
    permissionsService = PermissionsService(repository);
  });

  tearDown(() {
    reset(repository);
  });

  group('PermissionsService', () {
    test('checkPermission should call hasPermission', () async {
      when(repository.getPermissions()).thenAnswer((_) async => Stubs.grantedPermissionPair);

      await permissionsService.getPermissions();

      verify(repository.getPermissions()).called(1);
    });
  });
}

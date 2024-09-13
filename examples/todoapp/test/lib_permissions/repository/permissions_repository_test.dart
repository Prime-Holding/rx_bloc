import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todoapp/base/common_mappers/error_mappers/error_mapper.dart';
import 'package:todoapp/base/models/errors/error_model.dart';
import 'package:todoapp/lib_permissions/data_sources/local/permissions_local_data_source.dart';
import 'package:todoapp/lib_permissions/data_sources/remote/permissions_remote_data_source.dart';
import 'package:todoapp/lib_permissions/repositories/permissions_repository.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import 'permissions_repository_test.mocks.dart';

@GenerateMocks([PermissionsRemoteDataSource, PermissionsLocalDataSource])
void main() {
  late PermissionsRepository permissionsRepository;
  late ErrorMapper mockErrorMapper;
  late MockPermissionsRemoteDataSource mockPermissionsRemoteDataSource;
  late MockPermissionsLocalDataSource mockPermissionsLocalDataSource;

  setUp(() {
    mockErrorMapper = ErrorMapper(coordinatorBlocMockFactory());
    mockPermissionsRemoteDataSource = MockPermissionsRemoteDataSource();
    mockPermissionsLocalDataSource = MockPermissionsLocalDataSource();
    permissionsRepository = PermissionsRepository(
      mockErrorMapper,
      mockPermissionsRemoteDataSource,
      mockPermissionsLocalDataSource,
    );
  });

  group('PermissionsRepository', () {
    test(
        'should return permissions from remote data source and store them locally',
        () async {
      final Map<String, bool> permissions = {
        'permission1': true,
        'permission2': false,
      };

      when(mockPermissionsRemoteDataSource.getPermissions())
          .thenAnswer((_) async => permissions);

      final result = await permissionsRepository.getPermissions();

      expect(result, permissions);
      verify(mockPermissionsRemoteDataSource.getPermissions()).called(1);
      verify(mockPermissionsLocalDataSource.storePermissions(permissions))
          .called(1);
    });

    test('should handle error and return permissions from local data source',
        () async {
      final Map<String, bool> localPermissions = {
        'permission1': true,
        'permission2': false,
      };

      when(mockPermissionsRemoteDataSource.getPermissions())
          .thenThrow(NoConnectionErrorModel());
      when(mockPermissionsLocalDataSource.getPermissions())
          .thenReturn(localPermissions);

      final result = await permissionsRepository.getPermissions();

      expect(result, localPermissions);
      verify(mockPermissionsRemoteDataSource.getPermissions()).called(1);
      verify(mockPermissionsLocalDataSource.getPermissions()).called(1);
    });
  });
}

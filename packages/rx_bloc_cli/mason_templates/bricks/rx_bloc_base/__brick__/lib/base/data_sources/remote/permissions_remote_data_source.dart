{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/permissions_model.dart';

part 'permissions_remote_data_source.g.dart';

@RestApi()
abstract class PermissionsRemoteDataSource {
  factory PermissionsRemoteDataSource(Dio dio, {String baseUrl}) =
      _PermissionsRemoteDataSource;

  @GET('/api/permissions')
  Future<PermissionsModel> getPermissions();
}

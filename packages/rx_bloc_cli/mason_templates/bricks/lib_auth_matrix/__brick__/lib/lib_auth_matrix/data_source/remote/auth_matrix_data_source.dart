{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/auth_matrix_method_request.dart';
import '../../models/auth_matrix_response.dart';
import '../../models/payload/auth_matrix_payload_request.dart';

part 'auth_matrix_data_source.g.dart';

@RestApi()
abstract class AuthMatrixDataSource {
  factory AuthMatrixDataSource(Dio dio, {String baseUrl}) =
      _AuthMatrixDataSource;

  /// Initiates the authentication matrix process.
  ///
  /// - [action]: The action to be performed such as `changeAddress`, `makeTransaction`, etc.
  /// - [request]: The request body that contains the necessary user data to initiate the process.
  /// - Returns [AuthMatrixResponse] that determines the next authentication step.
  @POST('/api/auth-matrix/actions/{action}')
  Future<AuthMatrixResponse> initiate(
    @Path() String action,
    @Body() AuthMatrixPayloadRequest request,
  );

  /// Authenticates the user using the [transactionId] and the [request] body.
  ///
  /// - [transactionId]: The transaction identifier.
  /// - [request]: The request body that contains the necessary user data to authenticate the user.
  @POST('/api/auth-matrix/{transactionId}')
  Future<AuthMatrixResponse> authenticate(
    @Path() String transactionId,
    @Body() AuthMatrixMethodRequest request,
  );


}

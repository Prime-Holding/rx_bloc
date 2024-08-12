{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/mfa_method_request.dart';
import '../../models/mfa_response.dart';
import '../../models/payload/mfa_payload_request.dart';

part 'mfa_data_source.g.dart';

@RestApi()
abstract class MfaDataSource {
  factory MfaDataSource(Dio dio, {String baseUrl}) =
      _MfaDataSource;

  /// Initiates the authentication Multi-Factor Authentication.
  ///
  /// - [action]: The action to be performed such as `changeAddress`, `makeTransaction`, etc.
  /// - [request]: The request body that contains the necessary user data to initiate the process.
  /// - Returns [MfaResponse] that determines the next authentication step.
  @POST('/api/mfa/actions/{action}')
  Future<MfaResponse> initiate(
    @Path() String action,
    @Body() MfaPayloadRequest request,
  );

  /// Authenticates the user using the [transactionId] and the [request] body.
  ///
  /// - [transactionId]: The transaction identifier.
  /// - [request]: The request body that contains the necessary user data to authenticate the user.
  @POST('/api/mfa/{transactionId}')
  Future<MfaResponse> authenticate(
    @Path() String transactionId,
    @Body() MfaMethodRequest request,
  );


}

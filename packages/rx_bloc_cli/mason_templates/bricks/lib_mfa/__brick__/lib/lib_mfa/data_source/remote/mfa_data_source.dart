{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/payload/mfa_payload_request.dart';
import '../../models/mfa_method_request.dart';
import '../../models/mfa_response.dart';

part 'mfa_data_source.g.dart';

@RestApi()
abstract class MFADataSource {
  factory MFADataSource(Dio dio, {String baseUrl}) =
      _MFADataSource;

  /// Initiates the authentication Multi-Factor Authentication.
  ///
  /// - [action]: The action to be performed such as `changeAddress`, `makeTransaction`, etc.
  /// - [request]: The request body that contains the necessary user data to initiate the process.
  /// - Returns [MFAResponse] that determines the next authentication step.
  @POST('/api/mfa/actions/{action}')
  Future<MFAResponse> initiate(
    @Path() String action,
    @Body() MFAPayloadRequest request,
  );

  /// Authenticates the user using the [transactionId] and the [request] body.
  ///
  /// - [transactionId]: The transaction identifier.
  /// - [request]: The request body that contains the necessary user data to authenticate the user.
  @POST('/api/mfa/{transactionId}')
  Future<MFAResponse> authenticate(
    @Path() String transactionId,
    @Body() MFAMethodRequest request,
  );


}

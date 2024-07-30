{{> licence.dart }}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/payload/tfa_payload_request.dart';
import '../../models/tfa_method_request.dart';
import '../../models/tfa_response.dart';

part 'tfa_data_source.g.dart';

@RestApi()
abstract class TFADataSource {
  factory TFADataSource(Dio dio, {String baseUrl}) =
      _TFADataSource;

  /// Initiates the authentication Two-Factor Authentication.
  ///
  /// - [action]: The action to be performed such as `changeAddress`, `makeTransaction`, etc.
  /// - [request]: The request body that contains the necessary user data to initiate the process.
  /// - Returns [TFAResponse] that determines the next authentication step.
  @POST('/api/tfa/actions/{action}')
  Future<TFAResponse> initiate(
    @Path() String action,
    @Body() TFAPayloadRequest request,
  );

  /// Authenticates the user using the [transactionId] and the [request] body.
  ///
  /// - [transactionId]: The transaction identifier.
  /// - [request]: The request body that contains the necessary user data to authenticate the user.
  @POST('/api/tfa/{transactionId}')
  Future<TFAResponse> authenticate(
    @Path() String transactionId,
    @Body() TFAMethodRequest request,
  );


}

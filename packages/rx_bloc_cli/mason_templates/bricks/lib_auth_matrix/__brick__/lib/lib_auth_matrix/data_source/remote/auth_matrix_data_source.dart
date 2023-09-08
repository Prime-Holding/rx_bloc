import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/action_request.dart';
import '../../models/auth_matrix_cancel_model.dart';
import '../../models/auth_matrix_response.dart';
import '../../models/auth_matrix_verify.dart';

part 'auth_matrix_data_source.g.dart';

@RestApi()
abstract class AuthMatrixDataSource {
  factory AuthMatrixDataSource(Dio dio, {String baseUrl}) =
      _AuthMatrixDataSource;

  @POST('/api/authMatrix/actions/pinOnly')
  Future<AuthMatrixResponse> pinOnlyAuthMatrix(
    @Body() ActionRequest initRequest,
  );
  @POST('/api/authMatrix/actions/pinAndOtp')
  Future<AuthMatrixResponse> pinAndOtpAuthMatrix(
    @Body() ActionRequest initRequest,
  );
  @POST('/api/authMatrix/{transactionId}')
  Future<AuthMatrixResponse> verifyAuthMatrix(
    @Path() String transactionId,
    @Body() AuthMatrixVerify verifyRequest,
  );
  @DELETE('/api/authMatrix/actions/cancel')
  Future<void> cancelAuthMatrix(
    @Body() AuthMatrixCancelModel cancelModel,
  );
}

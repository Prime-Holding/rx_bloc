import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/pin_code_create_request.dart';
import '../../models/pin_code_update_request.dart';
import '../../models/pin_code_verify_request.dart';
import '../../models/pin_code_verify_response.dart';

part 'pin_code_data_source.g.dart';

@RestApi()
abstract class PinCodeDataSource {
  factory PinCodeDataSource(Dio dio, {String baseUrl}) = _PinCodeDataSource;

  /// Creates a new PIN code for the user.
  ///
  /// [PinCodeCreateRequest]:
  /// - [pinCode]: The PIN code to be created.
  @PATCH('/api/pin/create')
  Future<void> createPinCode(
    @Body() PinCodeCreateRequest pinCodeCreateRequest,
  );

  /// Verifies the user's existing PIN code.
  /// Optionally requests the token needed to update it.
  ///
  /// [PinCodeVerifyRequest]:
  /// - [pinCode]: The PIN code to be verified.
  /// - [requestUpdateToken]: Whether to request the token needed to update the PIN code.
  ///
  /// Returns [PinCodeVerifyResponse] which contains the token needed for the next step.
  @POST('/api/pin/verify')
  Future<PinCodeVerifyResponse> verifyPinCode(
    @Body() PinCodeVerifyRequest pinCodeVerifyRequest,
  );

  /// Updates the user's existing PIN code.
  ///
  /// [PinCodeUpdateRequest]:
  /// - [pinCode]: The new PIN code to be set.
  /// - [token]: The token needed to update the PIN code.
  @PATCH('/api/pin/update')
  Future<void> updatePinCode(
    @Body() PinCodeUpdateRequest pinCodeWithToken,
  );
}

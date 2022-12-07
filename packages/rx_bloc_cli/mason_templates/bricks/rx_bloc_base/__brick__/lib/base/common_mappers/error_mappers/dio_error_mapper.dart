part of 'error_mapper.dart';

extension _DioErrorMapper on DioError {
  ErrorModel asErrorModel() {
    if (type == DioErrorType.response && response != null) {
      if (response!.statusCode == 500) {
        try {
          // TODO: create error model from response
        } catch (e) {
          return ServerErrorModel();
        }
      }

      if (response!.statusCode == 403) {
        return AccessDeniedErrorModel();
      }

      if (response!.statusCode == 404) {
        return NotFoundErrorModel(
          message: response!.data is Map<String, dynamic>
              ? response!.data['message']
              : null,
        );
      }
    }

    if (type == DioErrorType.other && error is SocketException) {
      final errorCode = (error as SocketException).osError?.errorCode;
      if (errorCode == 101) {
        return NoConnectionErrorModel();
      }
      if (errorCode == 111) {
        return ConnectionRefusedErrorModel();
      }
    }

    return NetworkErrorModel();
  }
}

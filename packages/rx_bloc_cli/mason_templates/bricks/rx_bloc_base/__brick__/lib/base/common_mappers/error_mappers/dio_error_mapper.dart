part of 'error_mapper.dart';

extension _DioErrorMapper on DioException {
  static const String kConnectionRefusedError = 'Connection refused';
  ErrorModel asErrorModel() {
    if (type == DioExceptionType.badResponse && response != null) {
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
          message: response!.mapToString(),
        );
      }

      if (response!.statusCode == 422) {
        return ErrorServerGenericModel(
          message: response!.mapToString(),
        );
      }
    }

    if (type == DioExceptionType.unknown && error is SocketException) {
      final errorCode = (error as SocketException).osError?.errorCode;
      if (errorCode == 101) {
        return NoConnectionErrorModel();
      }
      final errorMessage = (error as SocketException).osError?.message ?? '';
      if (errorMessage.contains(kConnectionRefusedError)) {
        return ConnectionRefusedErrorModel();
      }
    }

    return NetworkErrorModel();
  }
}

{{> licence.dart }}

import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/subjects.dart';

import '../../lib_router/services/router_service.dart';

import '../extensions/auth_matrix_method_extensions.dart';
import '../models/auth_matrix_method.dart';
import '../models/auth_matrix_response.dart';

import '../models/payload/auth_matrix_payload_request.dart';
import '../repositories/auth_matrix_repository.dart';

class AuthMatrixService {
  AuthMatrixService(
    this._authMatrixRepository,
    this._routerService,
  );

  final RouterService _routerService;
  final AuthMatrixRepository _authMatrixRepository;

  final BehaviorSubject<AuthMatrixResponse> _onAuthenticationMethodComplete =
      BehaviorSubject();

  /// Initiates the auth matrix process by the given [request].
  ///
  /// - [request] is the request body that contains the necessary user data to initiate the process.
  /// Returns a [Stream] of [AuthMatrixResponse] that emits each step of the auth matrix process.
  Stream<AuthMatrixResponse> initiateAuthMatrix({
    required AuthMatrixPayloadRequest payload,
  }) async* {
    final response = await _authMatrixRepository.initiate(
      action: payload.type,
      request: payload,
    );

    yield* _executeAuthMethods(response);
  }

  /// Executes the auth matrix process by the given [response].
  /// - [response] is the response that contains the necessary data to execute the auth matrix process.
  /// Returns a [Stream] of [AuthMatrixResponse] that emits each step of the auth matrix process.
  Stream<AuthMatrixResponse> _executeAuthMethods(
    AuthMatrixResponse response,
  ) async* {
    AuthMatrixResponse? lastResponse = response;

    while (true) {
      if (lastResponse == null) {
        // Complete the stream if the auth method returns null
        break;
      }

      yield lastResponse;

      // Emit the last response to the stream when the auth method is completed.
      // this is exposed through the [onAuthenticationStepComplete] stream.
      _onAuthenticationMethodComplete.add(lastResponse);

      if (lastResponse.authMethod == AuthMatrixMethod.complete) {
        // Complete the stream if there is no more auth methods to be executed
        break;
      }

      lastResponse = await _executeAuthMethod(lastResponse: lastResponse);
    }
  }

  /// Deletes the auth matrix transaction by the given [transactionId].
  /// - [transactionId] is the unique auth matrix transaction id.
  /// Returns a [Future] that determines if the transaction was deleted successfully.
  Future<void> deleteAuthTransaction(String transactionId) =>
      _authMatrixRepository.deleteAuthTransaction(transactionId);

  /// Navigate to the next auth method route and execute it.
  ///
  /// - [lastResponse] is the last response that contains the necessary data to execute the auth method.
  /// Returns a [Future] of [AuthMatrixResponse] that determines the next steps in the auth matrix process.
  /// If the auth method returns null, the process is completed.
  Future<AuthMatrixResponse?> _executeAuthMethod({
    required AuthMatrixResponse lastResponse,
  }) async {
    final route = lastResponse.authMethod
        .createAuthMatrixMethodRoute(lastResponse.transactionId);

    if (route == null) {
      return null;
    }

    // The auth method is executed by navigating to the next route.
    // It must returns a [Result] of [AuthMatrixResponse]
    final result = await _routerService.push<Result<AuthMatrixResponse>>(
      route,
      extra: lastResponse,
    );

    if (result is ResultSuccess<AuthMatrixResponse>) {
      return result.data;
    }

    if (result is ResultError<AuthMatrixResponse>) {
      throw result.error;
    }

    return null;
  }

  Stream<AuthMatrixResponse> get onAuthenticationMethodComplete =>
      _onAuthenticationMethodComplete;

  void dispose() => _onAuthenticationMethodComplete.close();
}

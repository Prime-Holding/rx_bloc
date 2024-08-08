{{> licence.dart }}

import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/subjects.dart';

import '../../lib_router/services/router_service.dart';
import '../extensions/mfa_method_extensions.dart';
import '../models/payload/mfa_payload_request.dart';
import '../models/mfa_method.dart';
import '../models/mfa_response.dart';
import '../repositories/mfa_repository.dart';

class MfaService {
  MfaService(
    this._mfaRepository,
    this._routerService,
  );

  final RouterService _routerService;
  final MfaRepository _mfaRepository;

  final BehaviorSubject<MfaResponse> _onResponse = BehaviorSubject();

  /// Initiates the MFA process by the given [request].
  ///
  /// - [request] is the request body that contains the necessary user data to initiate the process.
  /// Returns a [Stream] of [MfaResponse] that emits each step of the MFA process.
  Stream<MfaResponse> authenticate({
    required MfaPayloadRequest payload,
  }) async* {
    final response = await _mfaRepository.initiate(
      action: payload.type,
      request: payload,
    );

    yield* _executeAuthMethods(response);
  }

  /// Executes the MFA process by the given [response].
  /// - [response] is the response that contains the necessary data to execute the MFA process.
  /// Returns a [Stream] of [MfaResponse] that emits each step of the MFA process.
  Stream<MfaResponse> _executeAuthMethods(
    MfaResponse response,
  ) async* {
    MfaResponse? lastResponse = response;

    while (true) {
      if (lastResponse == null) {
        // Complete the stream if the auth method returns null
        break;
      }

      yield lastResponse;

      // Emit the last response to the stream when the auth method is completed.
      // this is exposed through the [onResponse] stream.
      _onResponse.add(lastResponse);

      if (lastResponse.authMethod == MfaMethod.complete) {
        // Complete the stream if there are no more auth methods to be executed
        break;
      }

      lastResponse = await _executeAuthMethod(lastResponse: lastResponse);
    }
  }

  /// Navigate to the next auth method route and execute it.
  ///
  /// - [lastResponse] is the last response that contains the necessary data to execute the auth method.
  /// Returns a [Future] of [MfaResponse] that determines the next steps in the mfa process.
  /// If the auth method returns null, the process is completed.
  Future<MfaResponse?> _executeAuthMethod({
    required MfaResponse lastResponse,
  }) async {
    final route = lastResponse.authMethod
        .createMfaMethodRoute(lastResponse.transactionId);

    if (route == null) {
      return null;
    }

    // The auth method is executed by navigating to the next route.
    // It must returns a [Result] of [MfaResponse]
    final result = await _routerService.push<Result<MfaResponse>>(
      route,
      extra: lastResponse,
    );

    if (result is ResultSuccess<MfaResponse>) {
      return result.data;
    }

    if (result is ResultError<MfaResponse>) {
      throw result.error;
    }

    return null;
  }

  Stream<MfaResponse> get onResponse => _onResponse;

  void dispose() => _onResponse.close();
}

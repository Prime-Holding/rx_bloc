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

class MFAService {
  MFAService(
    this._mfaRepository,
    this._routerService,
  );

  final RouterService _routerService;
  final MFARepository _mfaRepository;

  final BehaviorSubject<MFAResponse> _onResponse = BehaviorSubject();

  /// Initiates the MFA process by the given [request].
  ///
  /// - [request] is the request body that contains the necessary user data to initiate the process.
  /// Returns a [Stream] of [MFAResponse] that emits each step of the MFA process.
  Stream<MFAResponse> authenticate({
    required MFAPayloadRequest payload,
  }) async* {
    final response = await _mfaRepository.initiate(
      action: payload.type,
      request: payload,
    );

    yield* _executeAuthMethods(response);
  }

  /// Executes the MFA process by the given [response].
  /// - [response] is the response that contains the necessary data to execute the MFA process.
  /// Returns a [Stream] of [MFAResponse] that emits each step of the MFA process.
  Stream<MFAResponse> _executeAuthMethods(
    MFAResponse response,
  ) async* {
    MFAResponse? lastResponse = response;

    while (true) {
      if (lastResponse == null) {
        // Complete the stream if the auth method returns null
        break;
      }

      yield lastResponse;

      // Emit the last response to the stream when the auth method is completed.
      // this is exposed through the [onResponse] stream.
      _onResponse.add(lastResponse);

      if (lastResponse.authMethod == MFAMethod.complete) {
        // Complete the stream if there is no more auth methods to be executed
        break;
      }

      lastResponse = await _executeAuthMethod(lastResponse: lastResponse);
    }
  }

  /// Navigate to the next auth method route and execute it.
  ///
  /// - [lastResponse] is the last response that contains the necessary data to execute the auth method.
  /// Returns a [Future] of [MFAResponse] that determines the next steps in the mfa process.
  /// If the auth method returns null, the process is completed.
  Future<MFAResponse?> _executeAuthMethod({
    required MFAResponse lastResponse,
  }) async {
    final route = lastResponse.authMethod
        .createMFAMethodRoute(lastResponse.transactionId);

    if (route == null) {
      return null;
    }

    // The auth method is executed by navigating to the next route.
    // It must returns a [Result] of [MFAResponse]
    final result = await _routerService.push<Result<MFAResponse>>(
      route,
      extra: lastResponse,
    );

    if (result is ResultSuccess<MFAResponse>) {
      return result.data;
    }

    if (result is ResultError<MFAResponse>) {
      throw result.error;
    }

    return null;
  }

  Stream<MFAResponse> get onResponse => _onResponse;

  void dispose() => _onResponse.close();
}

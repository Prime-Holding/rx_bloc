{{> licence.dart }}

import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/subjects.dart';

import '../../lib_router/services/router_service.dart';
import '../extensions/tfa_method_extensions.dart';
import '../models/payload/tfa_payload_request.dart';
import '../models/tfa_method.dart';
import '../models/tfa_response.dart';
import '../repositories/tfa_repository.dart';

class TFAService {
  TFAService(
    this._tfaRepository,
    this._routerService,
  );

  final RouterService _routerService;
  final TFARepository _tfaRepository;

  final BehaviorSubject<TFAResponse> _onResponse = BehaviorSubject();

  /// Initiates the TFA process by the given [request].
  ///
  /// - [request] is the request body that contains the necessary user data to initiate the process.
  /// Returns a [Stream] of [TFAResponse] that emits each step of the TFA process.
  Stream<TFAResponse> authenticate({
    required TFAPayloadRequest payload,
  }) async* {
    final response = await _tfaRepository.initiate(
      action: payload.type,
      request: payload,
    );

    yield* _executeAuthMethods(response);
  }

  /// Executes the TFA process by the given [response].
  /// - [response] is the response that contains the necessary data to execute the TFA process.
  /// Returns a [Stream] of [TFAResponse] that emits each step of the TFA process.
  Stream<TFAResponse> _executeAuthMethods(
    TFAResponse response,
  ) async* {
    TFAResponse? lastResponse = response;

    while (true) {
      if (lastResponse == null) {
        // Complete the stream if the auth method returns null
        break;
      }

      yield lastResponse;

      // Emit the last response to the stream when the auth method is completed.
      // this is exposed through the [onResponse] stream.
      _onResponse.add(lastResponse);

      if (lastResponse.authMethod == TFAMethod.complete) {
        // Complete the stream if there is no more auth methods to be executed
        break;
      }

      lastResponse = await _executeAuthMethod(lastResponse: lastResponse);
    }
  }

  /// Navigate to the next auth method route and execute it.
  ///
  /// - [lastResponse] is the last response that contains the necessary data to execute the auth method.
  /// Returns a [Future] of [TFAResponse] that determines the next steps in the tfa process.
  /// If the auth method returns null, the process is completed.
  Future<TFAResponse?> _executeAuthMethod({
    required TFAResponse lastResponse,
  }) async {
    final route = lastResponse.authMethod
        .createTFAMethodRoute(lastResponse.transactionId);

    if (route == null) {
      return null;
    }

    // The auth method is executed by navigating to the next route.
    // It must returns a [Result] of [TFAResponse]
    final result = await _routerService.push<Result<TFAResponse>>(
      route,
      extra: lastResponse,
    );

    if (result is ResultSuccess<TFAResponse>) {
      return result.data;
    }

    if (result is ResultError<TFAResponse>) {
      throw result.error;
    }

    return null;
  }

  Stream<TFAResponse> get onResponse => _onResponse;

  void dispose() => _onResponse.close();
}

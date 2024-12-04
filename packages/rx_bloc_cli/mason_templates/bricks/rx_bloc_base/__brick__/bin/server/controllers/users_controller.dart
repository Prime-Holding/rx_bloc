// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:shelf/shelf.dart';
import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';

import '../services/users_service.dart';
import '../utils/api_controller.dart';

// ignore_for_file: cascade_invocations

class UsersController extends ApiController {
  UsersController(this._usersService);

  final UsersService _usersService;

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.POST,
      '/api/register',
      _registerHandler,
    );

    // needs to have an access token, mocked for now
    router.addRequest(
      RequestType.POST,
      '/api/users/me/email/confirm',
      _confirmEmailHandler,
    );

    // needs to have an access token first
    // router.addRequest(
    //   RequestType.GET,
    //   '/api/users/me',
    // );

    // needs to have an access token, mocked for now
    router.addRequest(
      RequestType.PATCH,
      '/api/users/me',
      _sendSmsCodeHandler,
    );
    // needs to have an access token, mocked for now
    router.addRequest(
      RequestType.POST,
      '/api/users/me/phone/confirm',
      _confirmSmsCodeHandler,
    );
  }

  Future<Response> _registerHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final email = params['email'];
    final password = params['password'];

    return responseBuilder.buildOK(
      data: _usersService.registerOrFindUser(email, password).toJson(),
    );
  }

  Future<Response> _confirmEmailHandler(Request request) async {
    // final params = await request.bodyFromFormData();
    // final token = params['token'];

    /// mocked for now
    return responseBuilder.buildOK(
      data: _usersService
          .getUsers()
          .first
          .copyWith(
            confirmedCredentials:
                ConfirmedCredentialsModel(email: true, phone: false),
          )
          .toJson(),
    );
  }

  Future<Response> _sendSmsCodeHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final phoneNumber = params['phoneNumber'];

    /// mocked for now
    return responseBuilder.buildOK(
      data: _usersService
          .getUsers()
          .first
          .copyWith(phoneNumber: phoneNumber)
          .toJson(),
    );
  }

  Future<Response> _confirmSmsCodeHandler(Request request) async {
    // final params = await request.bodyFromFormData();
    // final smsCode = params['smsCode'];

    /// mocked for now
    return responseBuilder.buildOK(
      data: _usersService
          .getUsers()
          .first
          .copyWith(
            role: UserRole.user,
            confirmedCredentials:
                ConfirmedCredentialsModel(email: true, phone: true),
          )
          .toJson(),
    );
  }
}

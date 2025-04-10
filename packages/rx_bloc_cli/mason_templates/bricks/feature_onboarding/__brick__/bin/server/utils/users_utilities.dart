import 'package:shelf/shelf.dart';
import 'package:{{project_name}}/base/models/confirmed_credentials_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/models/user_role.dart';

import '../services/authentication_service.dart';
import '../services/users_service.dart';
import '../utils/response_builder.dart';
import '../utils/utilities.dart';

Future<Response> myUserHandler(
  Request request,
  ResponseBuilder responseBuilder,
  AuthenticationService authenticationService,
  UsersService usersService,
) async {
  final userId = authenticationService.getUserIdFromAuthHeader(request.headers);

  // Returns fake user in case the Registration flow has not been started
  // but user has access token
  // (when dev has authenticated through mock Login & ignored Registration)
  final user = usersService.getUserById(userId);
  if (user == null) {
    return responseBuilder.buildOK(
      data: UserModel(
        hasPin: true,
        id: generateRandomString(),
        email: 'test@test.com',
        phoneNumber: null,
        role: UserRole.tempUser,
        confirmedCredentials: ConfirmedCredentialsModel(
          email: true,
          phone: true,
        ),
      ).toJson(),
    );
  }

  return responseBuilder.buildOK(
    data: user.toJson(),
  );
}

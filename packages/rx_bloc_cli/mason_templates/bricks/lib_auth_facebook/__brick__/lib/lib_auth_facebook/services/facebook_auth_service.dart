import 'dart:developer';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../base/app/config/app_constants.dart';
import '../../base/repositories/push_notification_repository.dart';
import '../../lib_auth/repositories/auth_repository.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../models/facebook_auth_request_model.dart';
import '../repositories/facebook_auth_repository.dart';

class FacebookAuthService {
  FacebookAuthService(
    this._facebookAuthRepository,
    this._authRepository,
    this._pushSubscriptionRepository,
    this._permissionsService,
  );
  final FacebookAuthRepository _facebookAuthRepository;
  final AuthRepository _authRepository;
  final PushNotificationRepository _pushSubscriptionRepository;
  final PermissionsService _permissionsService;

  Future<bool> facebookLogin() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: [
          'email',
          'public_profile',
          'user_birthday',
          'user_friends',
          'user_gender',
          'user_link'
        ], //permissions depends on profile itself, maybe not all requested data will be avaliable
      ); // by default we request the email and the public profile
      // or FacebookAuth.i.login()
      if (result.status == LoginStatus.success) {
        // you are logged
        final AccessToken accessToken = result.accessToken!;
        final userInfo = await FacebookAuth.instance.getUserData(
          fields: 'email,name,picture,birthday,friends,gender,link',
        );
        print(accessToken.token);
        print(userInfo['email']);
        print(userInfo['user_gender']);
        print(userInfo['name']);
        print(userInfo['public_profile']);
        print(userInfo['birthday']);

        FacebookAuthRequestModel requestModel = FacebookAuthRequestModel(
          email: userInfo['email'],
          facebookToken: result.accessToken!.token,
          isAuthenticated: true,
          name: userInfo['name'],
          userPictureUrl: userInfo['picture']['data']['url'],
          userBirthday: userInfo['user_birthday'],
          userGender: userInfo['user_gender'],
          userLink: userInfo['user_link'],
          publicProfile: userInfo['public_profile'],
        );

        final authToken = await _facebookAuthRepository.facebookAuth(
            requestModel: requestModel);

        // Save response tokens
        await _authRepository.saveToken(authToken.token);
        await _authRepository.saveRefreshToken(authToken.refreshToken);
      } else {
        return false;
      }
      // Subscribe user push token
      try {
        final pushToken =
            await _pushSubscriptionRepository.getToken(vapidKey: webVapidKey);
        if (pushToken != null) {
          await _pushSubscriptionRepository.subscribe(pushToken);
        }
      } catch (e) {
        log(e.toString());
      }
      // Load permissions
      try {
        await _permissionsService.load();
      } catch (e) {
        log(e.toString());
      }
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> facebookLogout() async {
    await FacebookAuth.instance.logOut();
    await _authRepository.clearAuthData();
    return false;
  }
}

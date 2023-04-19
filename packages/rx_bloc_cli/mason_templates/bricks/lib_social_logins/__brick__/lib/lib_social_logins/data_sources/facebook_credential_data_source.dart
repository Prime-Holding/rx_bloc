{{> licence.dart }}

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/cancelled_error_model.dart';

import '../models/facebook_auth_request_model.dart';

class FacebookCredentialDataSource {
  Future<FacebookAuthRequestModel> getUsersFacebookCredential() async {
    final result = await FacebookAuth.instance.login(
      permissions: [
        'email',
        'public_profile',
        'user_birthday',
        'user_gender',
        'user_link'
      ],
    );
    final userInfo = await FacebookAuth.instance.getUserData(
      fields: 'email,name,picture,birthday,gender,link',
    ).onError((error, stackTrace) {
throw CancelledErrorModel();
});
    return FacebookAuthRequestModel(
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
  }
}

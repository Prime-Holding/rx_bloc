{{> licence.dart }}

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:{{project_name}}/lib_auth/models/auth_token_model.dart';

import '../config.dart';
import '../utils/utilities.dart';

class AuthToken {
  AuthToken._(
      this.token,
      this.refreshToken,
      );

  /// Generates a new auth token that's valid for one hour
  factory AuthToken.generateNew(
    String? userId,
  ) {
    final claimSet = JwtClaim(
      issuer: jwtIssuer,
      audience: jwtAudiences,
      payload: {
        'userId': userId ?? generateRandomString(),
      },
      maxAge: const Duration(hours: 1),
    );

    final authToken = issueJwtHS256(claimSet, jwtSigningKey);
    final refreshToken = generateRandomString();

    return AuthToken._(
      authToken,
      refreshToken,
    );
  }

  AuthTokenModel get toAuthTokenModel => AuthTokenModel(
        token,
        refreshToken,
      );

  /// The value of the access token
  final String token;

  /// The value of the refresh token
  final String refreshToken;

  bool get isValid {
    try {
      // Decode the token and verify the signature
      final decodedClaimSet = verifyJwtHS256Signature(token, jwtSigningKey);

      // Validate the issuer, audience and expiration
      decodedClaimSet.validate(
        issuer: jwtIssuer,
        audience: jwtAudiences.first,
      );
    } on JwtException {
      return false;
    }

    return true;
  }

  Map<String, Object?> toJson() => {
    'token': token,
    'refreshToken': refreshToken,
  };
}

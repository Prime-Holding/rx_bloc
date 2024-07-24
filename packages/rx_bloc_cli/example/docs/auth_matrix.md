
# Table of contents

1. [Overview](#overview)
3. [REST API Specification](#auth-matrix-api-specification)
4. [Authentication action](#authentication-action)
5. [Authentication method](#authentication-method)


# Overview
## Goal
The goal of the authentication matrix is to enable the business representative to configure the required authentication methods, such as `PIN/Biometric`, `OTP`, etc., for particular actions, such as `unlock`, `change password`, etc.

![auth matrix image][auth_matrix_img]

## Sequence diagram
The following sequence diagram illustrates the expected sequence of events when a specific action is protected by the `PIN/Biometric` and `OTP` authentication methods.

![auth matrix sequence img][auth_matrix_sequence_img]
## C4 Diagram
The following C4 diagram provides an overview of the component-level implementation of the library.
![auth matrix c4][auth_matrix_c4]

# Auth Matrix API Specification

## Summary

1. **Change Address Request**
- Endpoint: `POST /api/auth-matrix/actions/{actionType}`
- Sends a request to perform a particular action, which initiates the auth matrix flow.
  - Returns a response containing a document ID, security token, expiry time, authentication method, transaction ID, and payload.

2. **Authenticate the required auth matrix method with Security Token**
- Endpoint: `POST /api/auth-matrix/{id}`
- Sends a security token and payload containing a payload and type for authentication.
  - Returns a response containing a new document ID, a new security token, expiry time, authentication method, transaction ID, and payload.

## POST: /api/auth-matrix/actions/{actionType}

### Request

**Body:**
```jsonc
{    
 // ...payload specific properties,   
 "type": String, //The type of the payload. This is used to determine the type of the payload when serialising/deserializing.  
}   
```   
### Response

**Body:**
```jsonc
{
 // The unique auth matrix transaction id. It's used in the following payload requests to ensure the chain of requests.
 "transactionId": "1",

 // The draft document ids created by the initial auth matrix request. Once the user completes all authentication methods successfully, the documents will be marked as signed.
 "documentIds": List<int>,

  // The security token, which ensures the chain of auth matrix requests. It's used in the following payload requests to ensure the chain of requests.      
 "securityToken": String, 

  // The ISO 8601 expiration date of the auth matrix request.  
 "expires": String,

  /// The of auth matrix method (predefined enum) to be used for the following request.
 "authMethod": String,

 // Dynamic additional data along with the required response properties. Create custom AuthMatrixResponsePayload implementation for each case.  
 "payload": null 
}   
```
 ---   
## POST /api/auth-matrix/{id}

### Request

**Body:**
```jsonc
{    
  "securityToken": String,
  "payload": {
    // ...payload specific properties,
    "type": "pinBiometric"
  }
}   
```   
### Response

**Body:**
```jsonc
{
 // The unique auth matrix transaction id. It's used in the following payload requests to ensure the chain of requests.
 "transactionId": "1",

 // The draft document ids created by the initial auth matrix request. Once the user completes all authentication methods successfully, the documents will be marked as signed.
 "documentIds": List<int>,

  // The security token, which ensures the chain of auth matrix requests. It's used in the following payload requests to ensure the chain of requests.      
 "securityToken": String, 

  // The ISO 8601 expiration date of the auth matrix request.  
 "expires": String,

  /// The of auth matrix method (predefined enum) to be used for the following request.
 "authMethod": String,

 // Dynamic additional data along with the required response properties. Create custom AuthMatrixResponsePayload implementation for each case.  
 "payload": null 
}   
```    

# Authentication action
To add a new authentication method, such as `change password`, first, add the new method to the AuthMatrixAction enum. 
Then, extend the AuthMatrixPayloadRequest class to create a payload class for the new method, 
incorporating necessary payload fields and implementing methods for JSON serialization and equatability.

#### Step 1: Add a new case in the AuthMatrixAction enum
New case in the AuthMatrixAction needs to be added for each new authentication method.
```dart
enum AuthMatrixAction {
  // the other actions...
  changePassword,
}
```

#### Step 2: Add a new case in the AuthMatrixActionExtension
The payload for the new authentication method needs to be implemented by extending the AuthMatrixPayloadRequest class.
```dart
@JsonSerializable()
class AuthMatrixChangePasswordPayload extends AuthMatrixPayloadRequest
        with EquatableMixin {
  AuthMatrixChangePasswordPayload({
    required this.password,
  });

  final String password;

  @override
  String get type => AuthMatrixAction.changePassword.name;

  @override
  List<Object?> get props => [password];

  factory AuthMatrixChangePasswordPayload.fromJson(Map<String, dynamic> json) =>
          _$AuthMatrixChangePasswordPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() =>
          _$AuthMatrixChangePasswordPayloadToJson(this);
}
```

#### Step 3: Initiate the new authentication action
```dart
_service.initiateAuthMatrix(payload: AuthMatrixChangePasswordPayload(password: 'password'));
```
# Authentication method

To add a new method to the authentication matrix, such as email verification, first, add a new case `emailVerification` to the `AuthMatrixMethod` enum.
Create the `AuthMatrixEmailVerificationPayload` class extending `AuthMatrixPayloadRequest` and update the `AuthMatrixMethodExtension` class to parse this new payload.
Define the `AuthMatrixEmailVerificationRoute` class extending `GoRouteData` to handle routing.
Finally, add the new route path in the `RoutesPath` class and update the `createAuthMatrixMethodRoute` method to include the new enum case.


#### Step 1: Payload - Add a new case in the AuthMatrixMethod enum
```dart
enum AuthMatrixMethod {
  ...
  @JsonValue('EmailVerification')
  emailVerification,
```

#### Step 2: Payload -  Create a class that extends AuthMatrixPayloadRequest and uses the new AuthMatrixMethod
```dart
class AuthMatrixEmailVerificationPayload extends AuthMatrixPayloadRequest
    with EquatableMixin {
  AuthMatrixEmailVerificationPayload();

  @override
  String get type => AuthMatrixMethod.emailVerification.name;

  factory AuthMatrixEmailVerificationPayload.fromJson(Map<String, dynamic> json) => AuthMatrixEmailVerificationPayload();

  @override
  Map<String, dynamic> payloadToJson() => {};

  @override
  List<Object?> get props => [type];

  @override
  bool? get stringify => true;
}
```

#### Step 3: Payload - Add a new case in the AuthMatrixMethodExtension class to parse the new request method payload 
```dart
AuthMatrixPayloadRequest _payloadFromJson(Map<String, dynamic>? json, type) {
  switch (type) {
    ...
    case AuthMatrixMethod.emailVerification:
      return AuthMatrixEmailVerificationPayload.fromJson(json);
  }
```

#### Step 4: Route - Create a new route class that extends GoRouteData and uses the new AuthMatrixMethod
```dart
@TypedGoRoute<AuthMatrixEmailVerificationRoute>(
  path: RoutesPath.authMatrixEmailVerification,
)
class AuthMatrixEmailVerificationRoute extends GoRouteData implements RouteDataModel {
  const AuthMatrixEmailVerificationRoute(
    this.transactionId,
  );

  final String transactionId;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: ....
      );

  @override
  String get permissionName => RouteModel.authMatrix.permissionName;

  @override
  String get routeLocation => location;
}
```


#### Step 5: Route - Define the new route path in the RoutesPath class
```dart
class RoutesPath {
  ....
  static const authMatrixEmailVerification = '/auth-matrix/email-verification/:transactionId';
}
```


#### Step 6: Route - Add a new case in the createAuthMatrixMethodRoute method
```dart
extension AuthMatrixMethodX on AuthMatrixMethod {
  RouteDataModel? createAuthMatrixMethodRoute(String transactionId) {
   switch (this) {
      ...
      case AuthMatrixMethod.emailVerification:
        return AuthMatrixEmailVerificationRoute(transactionId);
    }
  }
```

[auth_matrix_img]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/feature/auth-matrix-refactoring-documentation/packages/rx_bloc_cli/example/docs/auth_matrix.png
[auth_matrix_sequence_img]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/feature/auth-matrix-refactoring-documentation/packages/rx_bloc_cli/example/docs/auth_matrix_sequence.png
[auth_matrix_c4]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/feature/auth-matrix-refactoring-documentation/packages/rx_bloc_cli/example/docs/auth_matrix_c4.png
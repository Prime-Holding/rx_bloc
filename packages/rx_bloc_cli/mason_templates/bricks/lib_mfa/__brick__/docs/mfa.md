
# Table of contents

1. [Overview](#overview)
3. [REST API Specification](#multi-factor-authentication-api-specification)
4. [Authentication action](#authentication-action)
5. [Authentication method](#authentication-method)


# Overview
## Goal
The goal of Multi-Factor Authentication is to enable the business representative to configure the required authentication methods, such as `PIN/Biometric`, `OTP`, etc., for particular actions, such as `unlock`, `change password`, etc.

![mfa image][mfa_img]

## Sequence diagram
The following sequence diagram illustrates the expected sequence of events when a specific action is protected by the `PIN/Biometric` and `OTP` authentication methods.

![mfa sequence img][mfa_sequence_img]
## C4 Diagram
The following C4 diagram provides an overview of the component-level implementation of the library.
![mfa c4][mfa_c4]

# Multi-Factor Authentication API Specification

## Summary

1. **Change Address Request**
- Endpoint: `POST /api/mfa/actions/{actionType}`
- Sends a request to perform a particular action, which initiates the mfa flow.
  - Returns a response containing a document ID, security token, expiry time, authentication method, transaction ID, and payload.

2. **Authenticate the required MFA method with Security Token**
- Endpoint: `POST /api/mfa/{id}`
- Sends a security token and payload containing a payload and type for authentication.
  - Returns a response containing a new document ID, a new security token, expiry time, authentication method, transaction ID, and payload.

## POST: /api/mfa/actions/{actionType}

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
 // The unique MFA transaction id. It's used in the following payload requests to ensure the chain of requests.
 "transactionId": "1",

 // The draft document ids created by the initial MFA request. Once the user completes all authentication methods successfully, the documents will be marked as signed.
 "documentIds": List<int>,

  // The security token, which ensures the chain of MFA requests. It's used in the following payload requests to ensure the chain of requests.      
 "securityToken": String, 

  // The ISO 8601 expiration date of the MFA request.  
 "expires": String,

  /// The of MFA method (predefined enum) to be used for the following request.
 "authMethod": String,

 // Dynamic additional data along with the required response properties.  
 "payload": null 
}   
```
 ---   
## POST /api/mfa/{id}

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
 // The unique MFA transaction id. It's used in the following payload requests to ensure the chain of requests.
 "transactionId": "1",

 // The draft document ids created by the initial MFA request. Once the user completes all authentication methods successfully, the documents will be marked as signed.
 "documentIds": List<int>,

  // The security token, which ensures the chain of MFA requests. It's used in the following payload requests to ensure the chain of requests.      
 "securityToken": String, 

  // The ISO 8601 expiration date of the MFA request.  
 "expires": String,

  /// The of MFA method (predefined enum) to be used for the following request.
 "authMethod": String,

 // Dynamic additional data along with the required response properties.  
 "payload": null 
}   
```    

# Authentication action
To add a new authentication method, such as `change password`, first, add the new method to the MfaAction enum. 
Then, extend the MfaPayloadRequest class to create a payload class for the new method, 
incorporating necessary payload fields and implementing methods for JSON serialization and equatability.

#### Step 1: Add a new case in the MfaAction enum
New case in the MfaAction needs to be added for each new authentication method.
```dart
enum MfaAction {
  // the other actions...
  changePassword,
}
```

#### Step 2: Create a class that extends MfaPayloadRequest
The payload for the new authentication method needs to be implemented by extending the MfaPayloadRequest class.
```dart
@JsonSerializable()
class MfaChangePasswordPayload extends MfaPayloadRequest
        with EquatableMixin {
  MfaChangePasswordPayload({
    required this.password,
  });

  final String password;

  @override
  String get type => MfaAction.changePassword.name;

  @override
  List<Object?> get props => [password];

  factory MfaChangePasswordPayload.fromJson(Map<String, dynamic> json) =>
          _$MfaChangePasswordPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() =>
          _$MfaChangePasswordPayloadToJson(this);
}
```

#### Step 3: Initiate the new authentication action
```dart
_service.authenticate(payload: MfaChangePasswordPayload(password: 'password'));
```
# Authentication method

To add a new method to the Multi-Factor Authentication, such as email verification, first, add a new case `emailVerification` to the `MfaMethod` enum.
Create the `MfaEmailVerificationPayload` class extending `MfaPayloadRequest` and update the `MfaMethodRequest` to parse this new payload.
Define the `MfaEmailVerificationRoute` class extending `GoRouteData` to handle routing.
Finally, add the new route path in the `RoutesPath` class and update the `createMfaMethodRoute` method to include the new enum case.


#### Step 1: Payload - Add a new case in the MfaMethod enum
```dart
enum MfaMethod {
  ...
  @JsonValue('EmailVerification')
  emailVerification,
```

#### Step 2: Payload -  Create a class that extends MfaPayloadRequest and uses the new MfaMethod
```dart
class MfaEmailVerificationPayload extends MfaPayloadRequest
    with EquatableMixin {
  MfaEmailVerificationPayload();

  @override
  String get type => MfaMethod.emailVerification.name;

  factory MfaEmailVerificationPayload.fromJson(Map<String, dynamic> json) => MfaEmailVerificationPayload();

  @override
  Map<String, dynamic> payloadToJson() => {};

  @override
  List<Object?> get props => [type];

  @override
  bool? get stringify => true;
}
```

#### Step 3: Payload - Add a new case in the MfaMethodRequest class to parse the new request method payload 
```dart
MfaPayloadRequest _payloadFromJson(Map<String, dynamic>? json, type) {
  switch (type) {
    ...
    case MfaMethod.emailVerification:
      return MfaEmailVerificationPayload.fromJson(json);
  }
```

#### Step 4: Route - Create a new route class that extends GoRouteData and uses the new mfaMethod
```dart
@TypedGoRoute<MfaEmailVerificationRoute>(
  path: RoutesPath.MfaEmailVerification,
)
class MfaEmailVerificationRoute extends GoRouteData implements RouteDataModel {
  const MfaEmailVerificationRoute(
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
  String get permissionName => RouteModel.mfa.permissionName;

  @override
  String get routeLocation => location;
}
```


#### Step 5: Route - Define the new route path in the RoutesPath class
```dart
class RoutesPath {
  ....
  static const mfaEmailVerification = '/mfa/email-verification/:transactionId';
}
```


#### Step 6: Route - Add a new case in the createMfaMethodRoute method
```dart
extension MfaMethodX on MfaMethod {
  RouteDataModel? createMfaMethodRoute(String transactionId) {
   switch (this) {
      ...
      case MfaMethod.emailVerification:
        return MfaEmailVerificationRoute(transactionId);
    }
  }
```

[mfa_img]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_cli/example/docs/mfa.png
[mfa_sequence_img]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_cli/example/docs/mfa_sequence.png
[mfa_c4]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_cli/example/docs/mfa_c4.png

# Table of contents

1. [Overview](#overview)
3. [REST API Specification](#tfa-api-specification)
4. [Authentication action](#authentication-action)
5. [Authentication method](#authentication-method)


# Overview
## Goal
The goal of Two-Factor Authentication is to enable the business representative to configure the required authentication methods, such as `PIN/Biometric`, `OTP`, etc., for particular actions, such as `unlock`, `change password`, etc.

![tfa image][tfa_img]

## Sequence diagram
The following sequence diagram illustrates the expected sequence of events when a specific action is protected by the `PIN/Biometric` and `OTP` authentication methods.

![tfa sequence img][tfa_sequence_img]
## C4 Diagram
The following C4 diagram provides an overview of the component-level implementation of the library.
![tfa c4][tfa_c4]

# Two-Factor Authentication API Specification

## Summary

1. **Change Address Request**
- Endpoint: `POST /api/tfa/actions/{actionType}`
- Sends a request to perform a particular action, which initiates the tfa flow.
  - Returns a response containing a document ID, security token, expiry time, authentication method, transaction ID, and payload.

2. **Authenticate the required tfa method with Security Token**
- Endpoint: `POST /api/tfa/{id}`
- Sends a security token and payload containing a payload and type for authentication.
  - Returns a response containing a new document ID, a new security token, expiry time, authentication method, transaction ID, and payload.

## POST: /api/tfa/actions/{actionType}

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
 // The unique TFA transaction id. It's used in the following payload requests to ensure the chain of requests.
 "transactionId": "1",

 // The draft document ids created by the initial TFA request. Once the user completes all authentication methods successfully, the documents will be marked as signed.
 "documentIds": List<int>,

  // The security token, which ensures the chain of TFA requests. It's used in the following payload requests to ensure the chain of requests.      
 "securityToken": String, 

  // The ISO 8601 expiration date of the TFA request.  
 "expires": String,

  /// The of TFA method (predefined enum) to be used for the following request.
 "authMethod": String,

 // Dynamic additional data along with the required response properties.  
 "payload": null 
}   
```
 ---   
## POST /api/tfa/{id}

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
 // The unique TFA transaction id. It's used in the following payload requests to ensure the chain of requests.
 "transactionId": "1",

 // The draft document ids created by the initial TFA request. Once the user completes all authentication methods successfully, the documents will be marked as signed.
 "documentIds": List<int>,

  // The security token, which ensures the chain of TFA requests. It's used in the following payload requests to ensure the chain of requests.      
 "securityToken": String, 

  // The ISO 8601 expiration date of the TFA request.  
 "expires": String,

  /// The of TFA method (predefined enum) to be used for the following request.
 "authMethod": String,

 // Dynamic additional data along with the required response properties.  
 "payload": null 
}   
```    

# Authentication action
To add a new authentication method, such as `change password`, first, add the new method to the TFAAction enum. 
Then, extend the TFAPayloadRequest class to create a payload class for the new method, 
incorporating necessary payload fields and implementing methods for JSON serialization and equatability.

#### Step 1: Add a new case in the TFAAction enum
New case in the TFAAction needs to be added for each new authentication method.
```dart
enum TFAAction {
  // the other actions...
  changePassword,
}
```

#### Step 2: Create a class that extends TFAPayloadRequest
The payload for the new authentication method needs to be implemented by extending the TFAPayloadRequest class.
```dart
@JsonSerializable()
class TFAChangePasswordPayload extends TFAPayloadRequest
        with EquatableMixin {
  TFAChangePasswordPayload({
    required this.password,
  });

  final String password;

  @override
  String get type => TFAAction.changePassword.name;

  @override
  List<Object?> get props => [password];

  factory TFAChangePasswordPayload.fromJson(Map<String, dynamic> json) =>
          _$TFAChangePasswordPayloadFromJson(json);

  @override
  Map<String, dynamic> payloadToJson() =>
          _$TFAChangePasswordPayloadToJson(this);
}
```

#### Step 3: Initiate the new authentication action
```dart
_service.authenticate(payload: TFAChangePasswordPayload(password: 'password'));
```
# Authentication method

To add a new method to the Two-Factor Authentication, such as email verification, first, add a new case `emailVerification` to the `TFAMethod` enum.
Create the `TFAEmailVerificationPayload` class extending `TFAPayloadRequest` and update the `TFAMethodRequest` to parse this new payload.
Define the `TFAEmailVerificationRoute` class extending `GoRouteData` to handle routing.
Finally, add the new route path in the `RoutesPath` class and update the `createTFAMethodRoute` method to include the new enum case.


#### Step 1: Payload - Add a new case in the TFAMethod enum
```dart
enum TFAMethod {
  ...
  @JsonValue('EmailVerification')
  emailVerification,
```

#### Step 2: Payload -  Create a class that extends TFAPayloadRequest and uses the new TFAMethod
```dart
class TFAEmailVerificationPayload extends TFAPayloadRequest
    with EquatableMixin {
  TFAEmailVerificationPayload();

  @override
  String get type => TFAMethod.emailVerification.name;

  factory TFAEmailVerificationPayload.fromJson(Map<String, dynamic> json) => TFAEmailVerificationPayload();

  @override
  Map<String, dynamic> payloadToJson() => {};

  @override
  List<Object?> get props => [type];

  @override
  bool? get stringify => true;
}
```

#### Step 3: Payload - Add a new case in the tfaMethodRequest class to parse the new request method payload 
```dart
tfaPayloadRequest _payloadFromJson(Map<String, dynamic>? json, type) {
  switch (type) {
    ...
    case tfaMethod.emailVerification:
      return tfaEmailVerificationPayload.fromJson(json);
  }
```

#### Step 4: Route - Create a new route class that extends GoRouteData and uses the new tfaMethod
```dart
@TypedGoRoute<tfaEmailVerificationRoute>(
  path: RoutesPath.TFAEmailVerification,
)
class tfaEmailVerificationRoute extends GoRouteData implements RouteDataModel {
  const tfaEmailVerificationRoute(
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
  String get permissionName => RouteModel.TFA.permissionName;

  @override
  String get routeLocation => location;
}
```


#### Step 5: Route - Define the new route path in the RoutesPath class
```dart
class RoutesPath {
  ....
  static const TFAEmailVerification = '/tfa/email-verification/:transactionId';
}
```


#### Step 6: Route - Add a new case in the createtfaMethodRoute method
```dart
extension tfaMethodX on tfaMethod {
  RouteDataModel? createtfaMethodRoute(String transactionId) {
   switch (this) {
      ...
      case tfaMethod.emailVerification:
        return tfaEmailVerificationRoute(transactionId);
    }
  }
```

[tfa_img]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/feature/auth-matrix-refactoring-2fa/packages/rx_bloc_cli/example/docs/2fa.png
[tfa_sequence_img]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/feature/auth-matrix-refactoring-2fa/packages/rx_bloc_cli/example/docs/2fa_sequence.png
[tfa_c4]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/feature/auth-matrix-refactoring-2fa/packages/rx_bloc_cli/example/docs/2fa_c4.png
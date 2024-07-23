
# Table of contents

1. [Overview](#overview)
3. [REST API Specification](#auth-matrix-api-specification)
4. [Authentication method](#project-structure)
5. [Authentication action](#project-structure)

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

[auth_matrix_img]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/feature/auth-matrix-refactoring-documentation/packages/rx_bloc_cli/example/docs/auth_matrix.png
[auth_matrix_sequence_img]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/feature/auth-matrix-refactoring-documentation/packages/rx_bloc_cli/example/docs/auth_matrix_sequence.png
[auth_matrix_c4]: https://raw.githubusercontent.com/Prime-Holding/rx_bloc/feature/auth-matrix-refactoring-documentation/packages/rx_bloc_cli/example/docs/auth_matrix_c4.png
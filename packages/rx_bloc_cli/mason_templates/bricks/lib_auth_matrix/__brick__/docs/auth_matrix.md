
# Table of contents

1. [Overview](#overview)
3. [REST API Specification](#auth-matrix-api-specification)
4. [Authentication method](#project-structure)
5. [Authentication action](#project-structure)

# Overview
## Goal
The of the authentication matrix is to enable the business representative to configure the required authentication methods such as `PIN/Biometric`, `OTP` etc for a particular action such as `unlock`,  `change password` etc.

![enter image description here](https://raw.githubusercontent.com/Prime-Holding/rx_bloc/develop/packages/rx_bloc_cli/example/docs/auth_matrix.png)

## Sequence diagram
The following sequence diagram illustrates the expected sequence of events when a specific action is protected by the `pinBiometric` and `OTP` authentication methods.

![enter image description here](https://github.com/Prime-Holding/rx_bloc/blob/develop/packages/rx_bloc_cli/example/docs/auth_matrix_sequence.png)
## C4 Diagram
The following C4 diagram represents the component-level implementation overview of the library.
![enter image description here](https://github.com/Prime-Holding/rx_bloc/blob/develop/packages/rx_bloc_cli/example/docs/auth_matrix_c4.png)

# Auth Matrix API Specification

## POST: /api/auth-matrix/actions/{actionType}

### Request

**Body:**
```json {    
 ...payload specific properties,   
 "type": String, //The type of the payload. This is used to determine the type of the payload when serialising/deserializing.  
}   
```   
### Response

**Body:**
```json {    
 "documentIds": List<int>, // The draft document ids created by the initial auth matrix request. Once the user completes all authentication methods successfully, the documents will be marked as signed.   
 "securityToken": String, // The security token, which ensures the chain of auth matrix requests. It's used in the following payload requests to ensure the chain of requests.   
 "expires": String, //The ISO 8601 expiration date of the auth matrix request.  
 "authMethod": String, // The of auth matrix method (predefined enum) to be used for the following request. "transactionId": "1", // The unique auth matrix transaction id. It's used in the following payload requests to ensure the chain of requests. "payload": null // /// Dynamic additional data along with the required response properties. Create custom AuthMatrixResponsePayload implementation for each case.  
}   
```    
 ---   
## POST /api/auth-matrix/{id}

### Request

**Body:**
```json {    
"securityToken": String, "payload": { ...payload specific properties, "type": "pinBiometric" }}   
```   
### Response

**Body:**
```json {    
 "documentIds": List<int>, // The draft document ids created by the initial auth matrix request. Once the user completes all authentication methods successfully, the documents will be marked as signed.   
 "securityToken": String, // The security token, which ensures the chain of auth matrix requests. It's used in the following payload requests to ensure the chain of requests.   
 "expires": String, //The Iso8601 expiration date of the auth matrix request.  
 "authMethod": String, // The auth matrix method to be used for the following request. "transactionId": "1", // The unique auth matrix transaction id. It's used in the following payload requests to ensure the chain of requests. "payload": null // /// Dynamic additional data to be received from the API along with the required response properties. Create custom AuthMatrixResponsePayload implementation for each case.  
}   
```    
 ---   
### Summary

1. **Change Address Request**
- Endpoint: `POST /api/auth-matrix/actions/{actionType}`
- Sends a request to perform a particular action, which initiates the auth matrix flow.
  - Returns a response containing a document ID, security token, expiry time, authentication method, transaction ID, and payload.

2. **Authenticate the required auth matrix method with Security Token**
- Endpoint: `POST /api/auth-matrix/{id}`
- Sends a security token and payload containing a payload and type for authentication.
  - Returns a response containing a new document ID, a new security token, expiry time, authentication method, transaction ID, and payload.
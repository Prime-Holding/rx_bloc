# Onboarding/Registration API Contracts

## Send E-mail and Password
**Endpoint**: `POST /api/register`  
**Description**: Sends the email and password to the backend to initiate registration. Backend sends the user a confirmation link to their e-mail address, and returns a temporary User to the mobile app, as well as auth tokens to identify the user consuming the following endpoints. This endpoint is also used to resume onboarding from a new device, so in case the user already exists it should return his UserModel with the current `confirmedCredentials`.

**Request**

```json
{
  "email": "user@example.com",
  "password": "securepassword123"
}
```

**Response**

Success (200): UserWithAuthTokenModel

```json
{
  "user": {  // UserModel
    "id": "12345",
    "email": "user@example.com",
    "phoneNumber": null,
    "role": "TempUser",
    "confirmedCredentials": {
        "email": false,
        "phone": false
    }
  },
  "authToken": {  // AuthTokenModel
    "token": "eyJhbG...",
    "refreshToken": "eyJhbG...",
  }
}
```

Error (400):

```json
{
  "error": "Invalid email format or weak password."
}
```

---

## Resend Confirmation E-mail
**Endpoint**: `POST /api/users/me/email/resend-confirmation`  
**Headers**: `Authorization: Bearer <token>`  
**Description**: Resends the confirmation link to the user.  

**Response**

Success (200): UserModel

```json
{
    "id": "12345",
    "email": "user@example.com",
    "phoneNumber": null,
    "role": "TempUser",
    "confirmedCredentials": {
        "email": false,
        "phone": false
    }
}
```

Error (400):

```json
{
  "error": "Invalid or expired user."
}
```

---

## Confirm E-mail
**Endpoint**: `POST /api/users/me/email/confirm`  
**Headers**: `Authorization: Bearer <token>`  
**Description**: Verifies the token in the confirmation link when the user opens it in the mobile app.

**Request**

```json
{
  "token": "uniqueToken123" 
}
```

**Response**

Success (200): UserModel

```json
{
    "id": "12345",
    "email": "user@example.com",
    "phoneNumber": null,
    "role": "TempUser",
    "confirmedCredentials": {
        "email": true,
        "phone": false
    }
}
```

Error (400):

```json
{
  "error": "Invalid or expired token."
}
```

---

## Submit Phone Number / Resend Confirmation Code
**Endpoint**: `PATCH /api/users/me`  
**Headers**: `Authorization: Bearer <token>`  
**Description**: Receives the phone number and sends an SMS code to the provided number.

**Request**

```json
{
  "phoneNumber": "+1234567890"
}
```

**Response**

Success (200):

```json
{
    "id": "12345",
    "email": "user@example.com",
    "phoneNumber": "+1234567890",
    "role": "TempUser",
    "confirmedCredentials": {
        "email": true,
        "phone": false
    }
}
```

Error (400):

```json
{
  "error": "Invalid phone number format."
}
```

---

## Confirm SMS Code
**Endpoint**: `POST /api/users/me/phone/confirm`  
**Headers**: `Authorization: Bearer <token>`  
**Description**: Validates the SMS code and finalizes the user profile. After this step, the TempUser becomes a User, and gains the correct permissions for accessing the rest of the app.

**Request**

```json
{
  "smsCode": "123456"
}
```

**Response**

Success (200):

```json
{
    "id": "12345",
    "email": "user@example.com",
    "phoneNumber": "+1234567890",
    "role": "User",
    "confirmedCredentials": {
        "email": true,
        "phone": true
    }
}
```

Error (400):

```json
{
  "error": "Invalid or expired SMS code."
}
```

---

## Fetch the currently logged-in user
**Endpoint**: `GET /api/users/me`  
**Headers**: `Authorization: Bearer <token>`  
**Description**: Fetches the currently logged-in user. This endpoint is used to resume onboarding from the same device.

**Response**

Success (200): UserModel

```json
{
    "id": "12345",
    "email": "user@example.com",
    "phoneNumber": null,
    "role": "TempUser",
    "confirmedCredentials": {
        "email": true,
        "phone": false
    }
}
```

Error (400):

```json
{
  "error": "Invalid or expired auth token."
}
```
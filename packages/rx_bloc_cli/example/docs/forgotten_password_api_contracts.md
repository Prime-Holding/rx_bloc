### **Forgotten Password API Contract**

#### **1. Request Password Reset**
**Endpoint:** `POST /api/password-reset/request`  
**Request Body:**
```json
{
  "email": "user@example.com"
}
```  
**Response:**
- **200 OK**
```json
{
  "message": "If an account exists with this email, you will receive a reset link."
}
```  
- **429 Too Many Requests**
```json
{
  "message": "Too many requests. Please try again in [time]."
}
```  


#### **2. Reset Password**
**Endpoint:** `POST /api/password-reset/confirm`  
**Request Body:**
```json
{
  "token": "reset_token_here",
  "new_password": "SecureP@ssw0rd!"
}
```  
**Response:**
- **200 OK**
```json
{
  "message": "Password reset successfully."
}
```  
- **400 Bad Request**
```json
{
  "message": "Invalid or expired token."
}
```  
- **422 Unprocessable Entity**
```json
{
  "message": "Password does not meet strength requirements."
}
```  
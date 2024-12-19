
---

## Resend SMS code
**Endpoint**: `POST /api/users/me/phone/resend`  
**Headers**: `Authorization: Bearer <token>`  
**Description**: Resends a SMS code to the set user's phone number.

**Response**

Success (200)

Error (400):

```json
{
  "error": "Unable to send SMS code."
}
```

---

## Fetch a list of country codes
**Endpoint**: `GET /api/country-codes`
**Description**: Retrieves a list of country code models each containing the country and the country code.

**Response**

Success (200):

```json
{
  "countryCodes" : [
    {
      "name": "Country 1",
      "code": "123"
    },
    // ...
    {
      "name": "Country Z",
      "code": "999"
    }
  ]
}
```
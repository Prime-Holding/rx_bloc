/// TODO: In order to use FCM and send push messages to target devices, you need to add your server key
const firebasePushServerKey = '';

/// A key for signing the JWT
const jwtSigningKey = 's3cr3t';

/// JWT Payload Fields
const jwtIssuer = 'Example Co inc.';
const jwtAudiences = <String>['api1.example.com', 'api2.example.com'];

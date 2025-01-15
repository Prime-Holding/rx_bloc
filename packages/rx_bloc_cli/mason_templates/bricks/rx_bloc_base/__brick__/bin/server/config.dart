/// TODO: In order to use FCM and send push messages to target devices, you need to add your project ID here.
const projectId = 'your_project_id';

/// The path to the service account key file
/// Note: In production environments, it is recommended to use environment variables to store the service account key.
const serviceAccountKeyPath = 'path/to/service_account_key.json';

/// A key for signing the JWT
const jwtSigningKey = 's3cr3t';

/// JWT Payload Fields
const jwtIssuer = 'Example Co inc.';
const jwtAudiences = <String>['api1.example.com', 'api2.example.com'];

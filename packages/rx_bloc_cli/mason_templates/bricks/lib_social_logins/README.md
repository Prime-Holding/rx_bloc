# lib_social_logins

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
A brick designed to integrate social login with Apple, Google and Facebook functionality into our application.

### Apple Authentication
It uses the [sign_in_with_apple][5] package.  
In order to make it work, fulfill the requirements described in its [documentation](https://pub.dev/documentation/sign_in_with_apple/latest/).

Supports iOS.

### Google Authentication
Google authentication uses [google_sign_in][6] package.
 
Follow the package documentation for registering your application and downloading Google Services file.(GoogleService-Info.plist/google-services.json)

`Android:`
For android integration you will need to copy ***google-services.json*** file to ***android/app/src/{name_of_the_environment}/*** 

`iOS:`
For iOS integration you will need to copy ***GoogleService-Info.plist*** file to ***ios/enviroments/{name_of_the_enviroment}/firebase/***

For any other configurations refer to the [google_sign_in][6] package.

### Facebook Authentication
Facebook authentication uses [flutter_facebook_auth][7] package.

`Step 1:`  
In order to make it work you must register your app in facebook developer console.

`Step 2:`  
There you will find your **app_id**, **client_token** and **app_name**.

`Step 3:`
- `3.1 Android:` Edit ***android/app/build.gradle***, paste parameters from step 2 in
 ```
productFlavors{
  name_of_the_enviroment{
  dimension "default"
            applicationIdSuffix ""
            versionNameSuffix ""
            resValue "string", "facebook_app_id", "insert_facebook_app_id_here"
            resValue "string", "facebook_client_token", "insert_client_token_here"
    }
  }
  ```

- `3.2 iOS:`
  Edit ***ios/Flutter/(flavor-name).xcconfig*** and paste parameters from step 2.


`Note:` Some requirements to be able to run application with this version of *facebook auth* is
- **flutter_secure_storage** package must be 8.0.0 version
- for iOS in ***Podfile*** platform must be at least 12
- for Android ***minSdkVersion*** must be at least 21.

All additional info about package and better explanation how to implement you can find in documentation [flutter_facebook_auth_documentation][7].


_Generated by [mason][1] 🧱_

## Getting Started 🚀

This is a starting point for a new brick.
A few resources to get you started if this is your first brick template:

- [Official Mason Documentation][2]
- [Code generation with Mason Blog][3]
- [Very Good Livestream: Felix Angelov Demos Mason][4]

[1]: https://github.com/felangel/mason
[2]: https://github.com/felangel/mason/tree/master/packages/mason_cli#readme
[3]: https://verygood.ventures/blog/code-generation-with-mason
[4]: https://youtu.be/G4PTjA6tpTU
[5]: https://pub.dev/packages/sign_in_with_apple
[6]: https://pub.dev/packages/google_sign_in
[7]: https://pub.dev/packages/flutter_facebook_auth
[8]: https://facebook.meedu.app/docs/5.x.x/intro
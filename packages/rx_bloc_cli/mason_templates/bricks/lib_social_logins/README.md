# lib_social_logins

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

A brick designed to integrate social login with Apple, Google and Facebook functionality into our application. It uses the [sign_in_with_apple][5] [google_sign_in][6] packages. To make them work, meet the requirements described in their documentation.
When you run the created project, don't forget to enable the "Sign in with Apple" capability for your bundleId.

Supports iOS.

Facebook authentication uses [flutter_facebook_auth][7] package. In order to make it work you must register your app in facebook developer console, there you will find your **app_id**, **client_token** and **app_name**,
which you need to add to ***Info.plist*** and on ***build.gradle*** files on places we already marked.

Some requirements to be able to run application with this version of *facebook auth* is **flutter_secure_storage** package must be 8.0.0 version,
for iOs in ***Podfile*** platform must be at least 12, for Android ***minSdkVersion*** at least 21.

All additional info about package and better explanation how to implement you can find in documentation [flutter_facebook_auth_documentation][8].


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
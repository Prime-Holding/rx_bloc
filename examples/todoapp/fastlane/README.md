fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### build_flutter_app

```sh
[bundle exec] fastlane build_flutter_app
```

Start an automatic build
Expected environment variables:
    - CREDENTIAL_ENCRYPTION_PASSWORD
    - CREDENTIAL_REPOSITORY_ACCESS_SECRET
    - tag_build_trigger_reason_tag_name
Expected input parameters:
    - platform: string (android, ios)
Example:
    fastlane build_flutter_app platform:android

### build_custom

```sh
[bundle exec] fastlane build_custom
```

Start a custom build
If the following environment variables are not set the task will prompt the user to enter them:
    - CREDENTIAL_ENCRYPTION_PASSWORD
    - CREDENTIAL_REPOSITORY_ACCESS_SECRET
Expected input parameters:
    - platform: string (android, ios)
    - build_name: string (1.2.0)
    - build_number: integer (121)
    - environment: string (development, sit, uat, production)
Example:
    fastlane build_custom platform:android build_name:1.2.0 build_number:121 environment:uat

### deploy

```sh
[bundle exec] fastlane deploy
```

Deploy the build artifacts to the environment specified in deployment.yaml
Expected environment variables:
    - CREDENTIAL_ENCRYPTION_PASSWORD
    - CREDENTIAL_REPOSITORY_ACCESS_SECRET

### deploy_debug_symbols

```sh
[bundle exec] fastlane deploy_debug_symbols
```

Deploy the debug symbols to firebase
Expected environment variables:
    - CREDENTIAL_ENCRYPTION_PASSWORD
    - CREDENTIAL_REPOSITORY_ACCESS_SECRET

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

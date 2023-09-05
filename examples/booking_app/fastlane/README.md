fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### build_bamboo

```sh
[bundle exec] fastlane build_bamboo
```

Start an automatic build from Bamboo
Expected Bamboo variables:
    - bamboo.mobile.distribution.encryption.password
    - bamboo.mobile.distribution.repository.access.secret
    - bamboo.TagBuildTriggerReason.tagName
Expected input parameters:
    - platform: string (android, ios)
Example:
    fastlane build_bamboo platform:android

### build_custom

```sh
[bundle exec] fastlane build_custom
```

Start a custom build
Expected environment variables:
    - mobile_distribution_encryption_password
    - bamboo_mobile_distribution_repository_access_secret
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
    - mobile_distribution_encryption_password
    - bamboo_mobile_distribution_repository_access_secret

### deploy_debug_symbols

```sh
[bundle exec] fastlane deploy_debug_symbols
```

Deploy the debug symbols to firebase
Expected environment variables:
    - mobile_distribution_encryption_password
    - bamboo_mobile_distribution_repository_access_secret

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

## Mobile Application Distribution Credentials

This repository contains signing certificates, key stores and provisioning profiles needed for
distribution of the mobile application for Android and iOS.
The credential files are encrypted using `openssl` with a password.

Both the encryption and decryption script expect an environment variable containing the credential encryption password.
It can be set using the following command:

```sh
export MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD=<PASSWORD>
```

_Note: To list all currently available environment variables, use `printenv` from your console._

### Preparing The Credentials

Within the generated content, there are two directories each containing platform specific files for signing and distribution of the app.
The scripts are pre-configured to function with a set of default values. Please make sure the file names are matching the ones described below.

Within the `android` directory, make sure you have the following files:
- [`android.jks`][keystore_creation_android]: keystore file used for signing the android app
- `key_alias.txt`: file containing the alias used in the keystore file
- `key_password.txt`: file containing the key password used in the keystore file
- `store_password.txt`: file containing the store password used in the keystore file
- [`service_account_key.json`][service_account_android]: service account key file for publishing the app to Google Play

Within the `ios` directory, make sure you have the following files:
- Provisioning profiles for each supported flavor (`<FLAVOR_NAME>_provisioning_profile.mobileprovision`)
- `keychain_password.txt`: file containing the password used for the local keychain
- [`distribution_certificate.p12`][distribution_certificate_p12_ios]: iOS certificate for distributing the app
- `distribution_certificate_password.txt`: file containing the password used for the `.p12` certificate file
- [`auth_key.p8`][auth_key_ios]: auth key file for publishing the app to the App Store

_Note: Optionally, you can keep the original names of the files (provisioning profiles, certificates, keystore, ...). 
In such case, be sure to rename the assigned values within the `decode.sh` script and your projects `Fastfile`._

_Note 2: You can quickly create a new `android.jks` keystore file using the following command:_

```
keytool -genkey -v -keyalg RSA -keysize 2048 -validity 10000 -keystore android.jks -alias {alias_name} -keypass {key_password} -storepass {store_password}
```

### Updating The Credentials

To update an existing file or add a new credentials file to the repo, for example an android keystore
for development environment, first add the file (`android_dev.jks`) to the `android` folder.
Then run the encryption script like this:

```sh
./encode.sh ./android/android_dev.jks
```

This will create a `android/android_dev.jks.enc` file which can be committed to the repository.
Also do not forget to add the original credential files to the `.gitignore` file so that they are not committed by accident.

### Decoding The Credentials

To decode the credentials run the decoding script and pass the credential type as a parameter.
Supported values are `android`, `ios`, `deploy_android`, `deploy_ios` and `firebase`.
It will create a new folder called `decoded` and place the decoded files there.

```sh
./decode.sh android
```

---

[keystore_creation_android]: https://developer.android.com/studio/publish/app-signing#generate-key
[service_account_android]: https://docs.fastlane.tools/actions/upload_to_play_store/#setup
[auth_key_ios]: https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api
[distribution_certificate_p12_ios]: https://support.magplus.com/hc/en-us/articles/203808748-iOS-Creating-a-Distribution-Certificate-and-p12-File
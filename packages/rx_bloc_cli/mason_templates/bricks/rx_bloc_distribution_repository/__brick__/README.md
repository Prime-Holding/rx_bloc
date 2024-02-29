## Mobile Application Distribution Credentials

This repository contains signing certificates, key stores and provisioning profiles needed for
distribution of the mobile application for Android and iOS.
The credential files are encrypted using `openssl` with a password.

Both the encryption and decryption script expect an environment variable containing the credential encryption password.
It can be set using the following command:

```sh
export mobile_distribution_encryption_password=<PASSWORD>
```

_Note: To list all currently available environment variables, use `printenv` from your console._

### Preparing The Credentials

Once generated, there will be two directories for credentials and files: one for `android` and one for `ios`.

Within the `android` directory, there are several pre-generated files: `keyAlias.txt`, `keyPassword` and `storePassword`.
Replace their contents with the respective values for the android keystore `alias` and passwords for `key` and `store`.
Also, make sure the directory contains the keystore file (`android.jsk`) used for signing the apk/app bundle file.

Within the `ios` directory, out of the box there are the following files pre-generated: `keychainPassword.txt` and `distributionCertificatePassword.txt`.
Make sure to replace the contents of the `keychainPassword.txt` with the password that will be used for the keychain storing the certificates and files.
The same way, replace the contents of the `distributionCertificatePassword.txt` which houses the password of the password protected certificate (`.p12`) used for iOS distribution.

### Updating The Credentials

To update an existing file or add a new credential file to the repo, for example an android keystore
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


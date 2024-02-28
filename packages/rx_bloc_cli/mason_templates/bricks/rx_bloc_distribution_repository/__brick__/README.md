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


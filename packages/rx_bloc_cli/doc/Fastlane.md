### Fastlane

#### Files/Credentials list:

In order to get started, first you need to prepare several files necessary for building the app and the deployment process.

---

For iOS, grab the latest provisioning profiles for each supported flavor from the [Apple Developer Console][apple_developer_console].

Additionally, create and export a distribution certificate in `.p12` format. It is suggested to use a strong password when exporting the certificate.

Create a file named `distributionCertificatePassword.txt` and paste the password inside.

Create a new strong password and paste it inside a newly created file named `keychainPassword.txt` . 
This password will be used for a keychain used for installing all the necessary certificates and provisioning profiles for the iOS build.

Optionally, if you want to deploy to Test Flight directly after the app has been built, you'll need to create an [App Store Connect API token][ios_auth_key_creation] and download it. The file name should have the following format: `AuthKey_{KEY_ID}.p8` where the `KEY_ID` is your unique id.

---

For Android, prepare the keystore that will be used for signing of the app bundle or create a new one using the following command:

```
keytool -genkey -v -keyalg RSA -keysize 2048 -validity 10000 -keystore android.jks -alias {alias_name} -keypass {key_password} -storepass {store_password}
```

Make sure the keystore file is named `android.jks` and take note of the alias name, key password and store password. 
For each of them, create a separate file named `keyAlias.txt`, `keyPassword.txt` and `storePassword.txt` and paste the respective contents inside

Optionally, if you want to deploy to Google Play directly after the app has been built, you'll need to setup a service account within the Google Cloud Platform Console page. Assign a new `.json` key to that service account and downlaod it for later use. Copy the generated email address of the service account and invite it as an Admin in the [Google Play Console][android_developer_console]. Additionally, make sure that the [Google Play Developer API][google_play_developer_api] is enabled on your existing project.

_Note: For an in-depth guide on how to setup a service account and assign it a key, please check the [setup section of Uploading to Play Store][android_service_key_creation] provided by Fastlane._

#### Repo structure:

* Update documentation to match newly created create_distribution command *

#### Fastfile amendments:

* Adjustments of flavor specific values and optional firebase values *
* Adjustments of provisioning_profile_map *
* Changes to fetch_credentials repo fetching *
* Changes to iOS specifics: TeamID , references to certificates/files *
* Changes to Android specifics: references to keystore/files *

#### Running commands locally:

Before running the commands, make sure you have Ruby and [Fastlane][fastlane_link] installed on your system. 
Fastfile and Gemfile use ruby under the hood.

* Commands to run fastlane locally *

#### Github secrets:

* Setting up github secrets *
* Overview of github action files *
* Triggering the pipeline *

---

[apple_developer_console]: https://developer.apple.com/
[android_developer_console]: https://play.google.com/console/developers
[fastlane_link]: https://docs.fastlane.tools/
[ios_auth_key_creation]: https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api
[android_service_key_creation]: https://docs.fastlane.tools/actions/upload_to_play_store/#setup
[google_play_developer_api]: https://console.developers.google.com/apis/api/androidpublisher.googleapis.com/?hl=en
### Fastlane

#### Distribution repository:

Create a new Github repository used for storing files and credentials for distribution of your app. 
Clone the repository and open the directory in the terminal. 
Using the [rx_bloc_cli][rx_bloc_cli_link] package, execute the following command:

```
rx_bloc_cli create_distribution .
```

The `create_distribution` command will populate the directory with the file structure required for things to work.
The generated `README` file contains steps on where to download and how to name the required files. 
Within the `android` and `ios` directories, paste the previously downloaded files and rename them accordingly.

You should also set the `MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD` variable in your terminal. 
This password will be used for encrypting/decrypting your files within the newly created repository.

Before committing any changes, make sure you encrypt all the files using the `encode.sh` script.

#### Fastfile amendments:

Inside the `{project_root}/fastlane/Fastfile`, you need to make changes to some variables in order for the configuration to work.

Replace the value of the `APPLE_DEVELOPMENT_TEAM` variable with your own [Apple Development Team ID][apple_development_team_id].

When downloading the `.p8` auth key, the file name should have the following format: `AuthKey_{KEY_ID}.p8` where the `KEY_ID` is your unique id. 
Take that value and paste it into the `IOS_P8_AUTH_KEY_ID` variable.

The value of the `IOS_P8_AUTH_KEY_ISSUER_ID` variable is the value retrieved from the `contentProviderPublicId` key within [this page][apple_issuer_id_details].
If more than one `contentProviderPublicId` with different values is present, make sure to use the one from the appropriate organization account name.

For each of the supported flavors, a separate firebase project will be required. 
Once each firebase project is configured, copy the app id of both Android and iOS configuration.
Update values for each flavor in the `firebase_app_id_map` dictionary.

For the iOS project, update the provisioning profile names for each flavor inside the `provisioning_profile_map` to match the names of individual provisioning profiles defined in the [Apple Developer Console][apple_provisioning_profiles_list].

Inside the `fetch_credentials` private lane, replace the repository url with the one matching your distribution repository. 
The url should be in the format allowing repository cloning using access tokens.
Check [this article][clone_github_repo_with_access_token] on how to setup and clone a github repository using an access token.

Make sure that the `MOBILE_DISTRIBUTION_REPOSITORY_ACCESS_SECRET` variable is present in your environment.
If not, set its value to be the value of the access token used for cloning of the distribution repository.

#### Running commands locally:

Before running the commands, make sure you have Ruby and [Fastlane][fastlane_link] installed on your system. 
Fastfile and Gemfile use ruby under the hood.

In order to run a local build of the android/ios app, execute the following command:

```
fastlane build_custom platform:<supported_platform> build_name:<build_version> build_number:<build_number> environment:<flavor>
```

where you need to provide the following details:
- supported_platform : ios, android
- flavor: development, sit, uat, production
- build_version: the actual app version (example: 1.2.0)
- build_number: the incremental build number

After the build has finished successfully, a `deployment.yaml` file will be generated along the platform specific artifacts. 
The `deployment.yaml` contains necessary details used for deploying the app.

To manually deploy the generated artifacts, use the following command:

```
fastlane deploy
```

For more details on that and other commands, as well as their arguments, please check out the `{project_root}/fastlane/README.md` file.

#### Github secrets:

* Retrieving github token*
* Setting up github secrets *
* Overview of github action files *
* Triggering the pipeline *

---

[apple_developer_console]: https://developer.apple.com/
[android_developer_console]: https://play.google.com/console/developers
[fastlane_link]: https://docs.fastlane.tools/
[rx_bloc_cli_link]: https://pub.dev/packages/rx_bloc_cli
[ios_auth_key_creation]: https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api
[android_service_key_creation]: https://docs.fastlane.tools/actions/upload_to_play_store/#setup
[google_play_developer_api]: https://console.developers.google.com/apis/api/androidpublisher.googleapis.com/?hl=en
[apple_development_team_id]: https://developer.apple.com/help/account/manage-your-team/locate-your-team-id/
[apple_issuer_id_details]: https://appstoreconnect.apple.com/WebObjects/iTunesConnect.woa/ra/user/detail
[apple_provisioning_profiles_list]: https://developer.apple.com/account/resources/profiles/list
[clone_github_repo_with_access_token]: https://kettan007.medium.com/how-to-clone-a-git-repository-using-personal-access-token-a-step-by-step-guide-ab7b54d4ef83
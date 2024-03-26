## Fastlane

### Distribution repository

Create a new Github repository used for storing files and credentials for distribution of your app.
Clone the repository and open the directory in the terminal.
Using the [rx_bloc_cli][rx_bloc_cli_link] package, execute the following command:

```
rx_bloc_cli create_distribution .
```

The `create_distribution` command will populate the directory with the file structure required for things to work.
The generated `README` file contains steps on where to download and how to name the required files.
Within the `android` and `ios` directories, paste the previously downloaded files and rename them accordingly.

Make sure that the `MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD` environment variable is present.
This variable will be used for encrypting/decrypting your files within the newly created repository.

Before committing any changes, make sure you encrypt all the files using the `encode.sh` script.

### Project & Fastfile amendments

For the iOS project, make sure you set project signing to manual and apply expected provisioning profile for each release configuration.
To do that, you need to:
- Open project in XCode
- Inside the targets section, select your `Runner` target
- Open the `Signing & Capabilities` tab
- Uncheck the `Automatically manage signing` checkmark in each of the release build configurations
- Select a fitting provisioning profile for each of the changed build configurations
- Save the changes in XCode

Inside the `{project_root}/fastlane/Fastfile`, you need to make changes to some variables in order for the configuration to work.

Replace the value of the `APPLE_DEVELOPMENT_TEAM` variable with your own [Apple Development Team ID][apple_development_team_id].

When downloading the `.p8` auth key, the file name should have the following format: `AuthKey_{KEY_ID}.p8` where the `KEY_ID` is your unique id.
Take that value and paste it into the `IOS_P8_AUTH_KEY_ID` variable.

The value of the `IOS_P8_AUTH_KEY_ISSUER_ID` variable is the value retrieved from the `contentProviderPublicId` key within [this page][apple_issuer_id_details].
If more than one `contentProviderPublicId` with different values is present, make sure to use the one from the appropriate organization account name.

Update the `PROJECT_DIRECTORY_NAME` variable with the name of the root directory in which the project is located.

Copy the url of the distribution repository and paste it inside the `DISTRIBUTION_REPOSITORY_URL` variable. 
Make sure you include the url without the `http://` and `https://` prefixes, as this path will be combined with the distribution repository access token. 
As for an example repo url `https://github.com/Prime-Holding/rx_bloc.git`, the `DISTRIBUTION_REPOSITORY_URL` would have the following value: `github.com/Prime-Holding/rx_bloc.git`  

For each of the supported flavors, prepare one or more firebase projects (based on your projects requirements).
Once each firebase project is configured, go to the `General` tab in the `Project settings` of your project in the Firebase Console.
Under `Your apps` section, copy the app id of both Android and iOS configuration by selecting the respective apps.
Update values for each supported flavor in the `firebase_app_id_map` dictionary within the `Fastfile`.

For the iOS project, update the provisioning profile names for each flavor inside the `provisioning_profile_map` dictionary.
Each key in the dictionary represents the flavor name, while the values are names of individual provisioning profiles defined in the [Apple Developer Console][apple_provisioning_profiles_list].
In case you've named your provisioning profiles differently, make sure to update the values with the proper file names within the `provisioning_profile_file_name_map` dictionary.

Inside the `fetch_credentials` private lane, replace the repository url with the one matching your distribution repository.
The url should be in the format allowing repository cloning using access tokens.
Check [this article][clone_github_repo_with_access_token] on how to setup and clone a github repository using an access token.

Make sure that the `MOBILE_DISTRIBUTION_REPOSITORY_ACCESS_SECRET` variable is present in your local environment.
If not, set its value to be the value of the access token used for cloning of the distribution repository.

```
export MOBILE_DISTRIBUTION_REPOSITORY_ACCESS_SECRET=<PASSWORD>
```

### Github pipeline

The generated project contains two reusable github workflows (one for building the iOS app and one for the Android one) and an example workflow which is run every time a tag with a specific name is pushed in your github repository.

If you haven't created an access token for your distribution repository in Github [using this guide][clone_github_repo_with_access_token], do so and take note of it.

Access the `Actions secrets and variables` within the settings page of your Github repository.
There you should define two repository secrets with the same values as in the local environments:
- `MOBILE_DISTRIBUTION_REPOSITORY_ACCESS_SECRET`: access token used for fetching the contents of the distribution repository
- `MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD`: password used for encrypting/decrypting content from the distribution repository

Within the `{project_root}/.github/workflows/build_and_deploy_app.yaml` file the default configuration builds the app but does not deploy it.
If you want to deploy your app after the build succeeds, change the `publish_to_store` variable within the respective jobs to `true` and commit the new changes.

The `build_android_app` job is ran on `ubuntu-latest` runners, while the `build_ios_app` job uses `macos-latest` runners. 
All jobs are ran on standard Github-hosted runners with the usual [usage limits][github_actions_usage_limits].

Once the apps are successfully built and signed, a `deployment.yaml` file along with the platform specific artifacts (`.aab` for Android, `.ipa` for iOS) will be generated. 
The `deployment.yaml` contains necessary details used for deploying the app. 
The `deployment.yaml` and the artifacts can be downloaded from the completed Github action from the Actions tab. 
In case of deploying the apps to the respective stores manually using the downloaded artifacts, please check the `Local distribution` section below. 

_Note: Once the github build is successfully done, two deployment files will be available: `android-deployment.yaml` and `ios-deployment.yaml`. 
Before you manually distribute artifacts for respective platforms, make sure to rename the deployment files to `deployment.yaml`._

In order to trigger a new build, push a new tag to the repository in one of the following formats:
`production-v1.2.3+45` or `my_awesome_tag_name-development-v1.2.3+45`

### Local distribution

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

To manually deploy the generated artifacts, use the following command:

```
fastlane deploy
```

For more details on that and other commands, as well as their arguments, please check out the `{project_root}/fastlane/README.md` file.

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
[github_actions_usage_limits]: https://docs.github.com/en/actions/learn-github-actions/usage-limits-billing-and-administration#usage-limits
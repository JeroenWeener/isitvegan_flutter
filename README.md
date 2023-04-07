# Is It Vegan
A Flutter application where users check if ingredients on packaging are vegan using OCR and AR.

## Architecture

This App is generated using the `base_app` brick provided by [Baseflow](https://baseflow.com). The app is structured to follow the [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) principles created by Robert C. Martin.

This means the app is split up into multiple independent packages listed in the `packages` folder. The template generates the following packages by default:

- **isitvegan_app**: Bootstrap project responsible for wiring up all packages in the right order.
- **isitvegan_ui**: Project representing the presentation layer. This is where all pages, widgets and BLoC classes should go.
- **isitvegan_core**: Project representing the business logic layer. This is where all use cases, domain classes and repository contracts are defined.

More details on the Baseflow architecture for Flutter applications can be found [here](https://docs.google.com/document/d/1QvjxjiNc1MCb_Yn36xcXJxAzSYwhNMk5oslSacRqI3A/edit?usp=sharing).

## TODO-list after generating a new project

- Run `melos bootstrap` to initialize the project.
- Run `melos get` to run flutter packages get in all packages.
- Run `melos generate` to run all needed code generators.
- Run `melos fix:apply` to fix any analysis issues created while generating.

## TODO Android Release

The steps below are required to prepare the Android application for release and ensure the continuous delivery scripts work successfully. The commands used in these steps assume you are running on a Linux or macOS machine. If you are on Windows these commands might be slightly different. 

Part of these steps use GnuPG (binary name `gpg`) to encrypt sensitive information. GnuPG is pre-installed on most Linux distributions, however not on macOS. Installing GnuPG on macOS is done using one of the package managers:

- [Homebrew](http://brew.sh/): `brew install gnupg gnupg2`
- [MacPorts](https://www.macports.org/): `sudo port install gnupg gnupg2`

- In `packages/*_app/android` run `keytool -genkey -v -keystore ./upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload` to generate an upload key.
- Make sure to update `key.properties` with the password. The placeholder values will make release builds fail.
- Do not add key.properties to git.
- Navigate to `packages/*_app/android` and execute `gpg -c --armor key.properties`.
- Save the passphrase to Github Actions' secret `ANDROID_KEY_PASSPHRASE`.
- Navigate to `packages/*_app/android` and execute `gpg -c --armor upload-keystore.jks`.
- Save the passphrase to Github Actions' secret `ANDROID_KEYSTORE_PASSPHRASE`.
- Save the output of `cat key.properties.asc` to `ANDROID_KEY_ASC`.
- Save the output of `cat upload-keystore.jks.asc` to `ANDROID_KEYSTORE_ASC`.
- Save the passphrases used in the Baseflow 1password. That way we don't lose them.
- Save the `key.properties.asc` and `upload-keystore.jks.asc` in Baseflow 1password.
- Create a Google play service-account with the customer.
- Save the Google play service-account JSON as `PLAY_STORE_GSERVICE_ACCOUNT` in the github secrets.
- Run your first Android build using `melos build:android` and manually upload the resulting binary (`packages/isitvegan_app/build/app/outputs/bundle/release/isitvegan_app.aab`) to Google Play internal testing.

## TODO iOS Release

The steps below are required to prepare the iOS application for release and ensure the continuous delivery scripts work successfully. The steps below require a macOS machine and won't work on a Linux or Windows machine.

Part of these steps use GnuPG (binary name `gpg`) to encrypt sensitive information. GnuPG is pre-installed on most Linux distributions, however not on macOS. Installing GnuPG on macOS is done using one of the package managers:
- [Homebrew](http://brew.sh/): `brew install gnupg gnupg2`
- [MacPorts](https://www.macports.org/): `sudo port install gnupg gnupg2`

- Go to [Apple Developer](https://developer.apple.com/account/resources/identifiers/list/bundleId) and add com.jwindustries..
- Go to [App Store Connect](https://appstoreconnect.apple.com/apps) and add a new app with com.jwindustries. as Bundle ID.
- SKU (Stock Keeping Unit) is a value Apple will include in the reports and can be used by the organization to identify the app. Usually the value used is the same as the bundle identifier, but could be anything as long as it is unique within the organization.
- Open KeyChain on you MacOs device. [Follow the steps](https://help.apple.com/developer-account/#/devbfa00fef7) to create a certificate singing request.
- Go to the [Apple Website](https://developer.apple.com/account/resources/certificates/add) and select Apple Distribution.
- Upload the Certificate Signing Request file created with Keychain.
- Download the certificate after uploading the request.
- Import the certificate in Keychain.
- Export a .p12 file from the imported certificate. Save the password to Github Actions Secrets `P12_PASSWORD`.
- Visit [Apple Profiles](https://developer.apple.com/account/resource/profiles/add). Select App Store, under Distribution.
- For `App ID` select the app created previously.
- For `Select certificate` select the certificate created previously. And give the profile a name in the next step.
- Download the provisioning profile.
- Save all asc outputs and passphrases used in the Baseflow 1password. That way we don't lose them.
- In your terminal navigate to .p12 file location and execute `gpg -c --armor <name_of_file>.mobileprovision`.
- Save the passphrase to Github Actions' secret `IOS_PROVISIONING_PROFILE_PASSWORD`.
- In your terminal navigate to .cert file location and execute `gpg -c --armor <name_of_file>.p12`.
- Save the passphrase to Github Actions' secret `IOS_CERTIFICATE_PASSWORD`.
- Save the output of `cat <name_of_file>.mobileprovision.asc` to `IOS_PROVISIONING_PROFILE_ASC`.
- Save the output of `cat <name_of_file>.p12.asc` to `IOS_CERTIFICATE_ASC`.
- Update `export-options.plist` with the TeamID at `<ENTER TEAM CODE HERE>`.
- Update `export-options.plist` with the name of the provisioning profile at `<ENTER PROVISIONING NAME HERE>`.
- Open the project in XCode and disable automatic code signing in Release flavors and set the provisioning profile to the one imported above.
- This should change `packages/isitvegan_app/ios/Runner.xcodeproj/project.pbxproj` by adding `DEVELOPMENT_TEAM`, `PROVISIONING_PROFILE_SPECIFIER`, `CODE_SIGN_IDENTITY` and `CODE_SIGN_STYLE`.
- Go to [AppStoreConnect](https://appstoreconnect.apple.com/access/api/new) and create a new API key.
- Give the API key a name and set `Access` to `App manager`, any other role will fail the deployments.
- Download the API key, and save the `Issuer ID` and `Key ID`.
- Go to Github Actions and save the Issuer ID and Key ID in `APP_STORE_ISSUER_ID` and `APP_STORE_API_KEY_ID` respectively.

## Melos

Managing a project that consists out of multiple packages can be quite challenging. Flutter commands need to be executed in the correct folder and in some cases you just want to execute on command to build the whole solution.

To help simplify working with a multi package application, this project is configured to use [Melos](https://pub.dev/packages/melos).

### Installing Melos

As [Melos](https://pub.dev/packages/melos) is a Dart package installing [Melos](https://pub.dev/packages/melos) is as easy as running:

```shell
dart pub global activate melos
```

When the command completes [Melos](https://pub.dev/packages/melos) is ready to be used.

### Bootstrapping

The first time this project is generated or everytime new packages are introduced it is important to bootstrap [Melos](https://pub.dev/packages/melos). To do so run the following command:

```shell
melos bootstrap
```

Bootstrapping does two important things:

1. Install all packages dependencies (internally using `pub get`).
2. Locally linking projects together.

After bootstrapping the application it is not yet ready for use. The code generation tools need to generate some files first, run `melos generate`.

### Preconfigured Melos scripts

To simplify the usage of [Melos](https://pub.dev/packages/melos) the following scripts are already preconfigured (see the [melos.yaml] file for details):

```shell
# Run dart analyze for all packages
melos run analyze

# Run flutter format for all packages
melos run format

# Build the App for all supported platforms
melos run build:all

# Build the App for a specific platform
melos run build:<android|ios|macos|linux|web|windows>

# Run tests for all packages
melos run test

# Run test for a specific package (lets you select the package)
melos run test:selective

# Run the application in debug mode
melos run debug

# Do a deep clean, which can be used to establish "pristine" checkout status
melos run clean:deep # Important: this removes all directories, files and changes that have not been committed.

# Run all code generation tools once (build_runner & l10n)
melos generate

# Run build_runner once in all packages
melos build_runner || melos build_runner:build

# Run build_runner in watch mode
melos build_runner:watch

# Generate the localization files
melos l10n
```

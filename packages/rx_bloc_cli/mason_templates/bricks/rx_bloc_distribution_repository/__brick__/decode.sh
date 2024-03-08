#!/bin/bash

ANDROID_KEYSTORE=android.jks
ANDROID_SERVICE_ACCOUNT_KEY=service_account_key.json
IOS_DISTRIBUTION_CERTIFICATE_P12=distribution_certificate.p12
IOS_AUTH_KEY_P8=auth_key.p8
IOS_PROVISION_PROFILES=( development_provisioning_profile.mobileprovision
                         sit_provisioning_profile.mobileprovision
                         uat_provisioning_profile.mobileprovision
                         production_provisioning_profile.mobileprovision  )

set -e

USAGE="Usage: decode.sh android|ios|deploy_android|deploy_ios|firebase"
CREDENTIAL_TYPES=('android' 'ios' 'deploy_android' 'deploy_ios' 'firebase')

if [ -z ${MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD+x} ]; then
    echo "Error: the MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD environment variable is not set"
    exit 1
fi

if (( $# != 1 )); then
    echo $USAGE && exit 2
fi

if ! echo "${CREDENTIAL_TYPES[@]}" | grep -qw "$1"; then
    echo $USAGE && exit 3
fi

function decode() {
    echo "Decoding file $1 into $2"
    openssl enc \
        -d \
        -aes-256-cbc \
        -pbkdf2 \
        -in $1 \
        -out $2 \
        -pass env:MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD
}

if [ $1 == 'android' ]; then
    mkdir -p ./decoded/android
    decode ./android/$ANDROID_KEYSTORE.enc ./decoded/android/$ANDROID_KEYSTORE
    decode ./android/key_alias.txt.enc ./decoded/android/key_alias.txt
    decode ./android/key_password.txt.enc ./decoded/android/key_password.txt
    decode ./android/store_password.txt.enc ./decoded/android/store_password.txt
fi

if [ $1 == 'deploy_android' ]; then
    mkdir -p ./decoded/android
    decode ./android/$ANDROID_SERVICE_ACCOUNT_KEY.enc ./decoded/android/$ANDROID_SERVICE_ACCOUNT_KEY
fi

if [ $1 == 'ios' ]; then
    mkdir -p ./decoded/ios
    decode ./ios/$IOS_DISTRIBUTION_CERTIFICATE_P12.enc ./decoded/ios/$IOS_DISTRIBUTION_CERTIFICATE_P12
    decode ./ios/distribution_certificate_password.txt.enc ./decoded/ios/distribution_certificate_password.txt
    decode ./ios/keychain_password.txt.enc ./decoded/ios/keychain_password.txt

    # Decode the provisioning profiles
    for file in "${IOS_PROVISION_PROFILES[@]}"; do
      decode "./ios/$file.enc" "./decoded/ios/$file"
    done
fi

if [ $1 == 'deploy_ios' ]; then
    mkdir -p ./decoded/ios
    decode ./ios/$IOS_AUTH_KEY_P8.enc ./decoded/ios/$IOS_AUTH_KEY_P8
fi

if [ $1 == 'firebase' ]; then
    mkdir -p ./decoded/firebase
    decode ./firebase/firebase_token.txt.enc ./decoded/firebase/firebase_token.txt
fi

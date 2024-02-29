#!/bin/bash

ANDROID_KEYSTORE=android.jks
ANDROID_SERVICE_ACCOUNT_KEY=service_account_key.json
IOS_DISTRIBUTION_CERTIFICATE_P12=distribution_certificate.p12
IOS_AUTH_KEY_P8=AuthKey.p8
IOS_PROVISION_PROFILES=( Development_Provisioning_Profile.mobileprovision
                         SIT_Provisioning_Profile.mobileprovision
                         UAT_Provisioning_Profile.mobileprovision
                         Production_Provisioning_Profile.mobileprovision  )

set -e

USAGE="Usage: decode.sh android|ios|deploy_android|deploy_ios|firebase"
CREDENTIAL_TYPES=('android' 'ios' 'deploy_android' 'deploy_ios' 'firebase')

if [ -z ${mobile_distribution_encryption_password+x} ]; then
    echo "Error: the mobile_distribution_encryption_password environment variable is not set"
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
        -pass env:mobile_distribution_encryption_password
}

if [ $1 == 'android' ]; then
    mkdir -p ./decoded/android
    decode ./android/$ANDROID_KEYSTORE.enc ./decoded/android/$ANDROID_KEYSTORE
    decode ./android/keyAlias.txt.enc ./decoded/android/keyAlias.txt
    decode ./android/keyPassword.txt.enc ./decoded/android/keyPassword.txt
    decode ./android/storePassword.txt.enc ./decoded/android/storePassword.txt
fi

if [ $1 == 'deploy_android' ]; then
    mkdir -p ./decoded/android
    decode ./android/$ANDROID_SERVICE_ACCOUNT_KEY.enc ./decoded/android/$ANDROID_SERVICE_ACCOUNT_KEY
fi

if [ $1 == 'ios' ]; then
    mkdir -p ./decoded/ios
    decode ./ios/$IOS_DISTRIBUTION_CERTIFICATE_P12.enc ./decoded/ios/$IOS_DISTRIBUTION_CERTIFICATE_P12
    decode ./ios/distributionCertificatePassword.txt.enc ./decoded/ios/distributionCertificatePassword.txt
    decode ./ios/keychainPassword.txt.enc ./decoded/ios/keychainPassword.txt

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
    decode ./firebase/firebaseToken.txt.enc ./decoded/firebase/firebaseToken.txt
fi

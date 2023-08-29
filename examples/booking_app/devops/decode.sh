#!/bin/sh

set -e

USAGE="Usage: decode.sh android|ios|deploy_android|deploy_ios|firebase"
CREDENTIAL_TYPES=('android' 'ios' 'deploy_android' 'deploy_ios' 'firebase')

if [ -z ${flutter_app_mobile_distribution_encryption_password+x} ]; then
    echo "Error: the flutter_app_mobile_distribution_encryption_password environment variable is not set"
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
        -pass env:flutter_app_mobile_distribution_encryption_password
}

if [ $1 == 'android' ]; then
    mkdir -p ./decoded/android
    decode ./android/android.jks.enc ./decoded/android/android.jks
    decode ./android/keyAlias.txt.enc ./decoded/android/keyAlias.txt
    decode ./android/keyPassword.txt.enc ./decoded/android/keyPassword.txt
    decode ./android/storePassword.txt.enc ./decoded/android/storePassword.txt
fi

if [ $1 == 'deploy_android' ]; then
    mkdir -p ./decoded/android
    decode ./android/pc-api-0000000000000000000-000-00000xxxx00x.json.enc ./decoded/android/pc-api-0000000000000000000-000-00000xxxx00x.json
fi

if [ $1 == 'ios' ]; then
    mkdir -p ./decoded/ios
    decode ./ios/bookingapp_distribution.p12.enc ./decoded/ios/bookingapp_distribution.p12
    decode ./ios/BookingApp_Mobile_Dev_Distribution.mobileprovision.enc ./decoded/ios/BookingApp_Mobile_Dev_Distribution.mobileprovision
    decode ./ios/BookingApp_Mobile_Staging_Distribution.mobileprovision.enc ./decoded/ios/BookingApp_Mobile_Staging_Distribution.mobileprovision
    decode ./ios/BookingApp_Mobile_Production_Distribution.mobileprovision.enc ./decoded/ios/BookingApp_Mobile_Production_Distribution.mobileprovision
    decode ./ios/distributionCertificatePassword.txt.enc ./decoded/ios/distributionCertificatePassword.txt
    decode ./ios/keychainPassword.txt.enc ./decoded/ios/keychainPassword.txt
fi

if [ $1 == 'deploy_ios' ]; then
    mkdir -p ./decoded/ios
    decode ./ios/AuthKey_X00X00XXX0.p8.enc ./decoded/ios/AuthKey_X00X00XXX0.p8
fi

if [ $1 == 'firebase' ]; then
    mkdir -p ./decoded/firebase
    decode ./firebase/firebaseToken.txt.enc ./decoded/firebase/firebaseToken.txt
fi

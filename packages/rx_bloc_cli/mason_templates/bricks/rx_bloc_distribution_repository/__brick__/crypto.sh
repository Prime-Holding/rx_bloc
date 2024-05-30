#!/bin/bash

ANDROID_KEYSTORE=android.jks
ANDROID_SERVICE_ACCOUNT_KEY=service_account_key.json
IOS_DISTRIBUTION_CERTIFICATE_P12=distribution_certificate.p12
IOS_AUTH_KEY_P8=auth_key.p8
IOS_PROVISION_PROFILES=( development_provisioning_profile.mobileprovision
                         sit_provisioning_profile.mobileprovision
                         uat_provisioning_profile.mobileprovision
                         production_provisioning_profile.mobileprovision  )

#### Setup ####

CMD=$1 # Selected command
MODE=$2 # Selected mode for chosen command

set -e

AVAILABLE_COMMANDS=('encode' 'decode')
AVAILABLE_MODES=('file' 'android' 'ios' 'deploy_android' 'deploy_ios' 'firebase' 'all')
MODES_STR=$(printf "%s|" "${AVAILABLE_MODES[@]}"); MODES_STR=${MODES_STR%|}

# Helper function which decides whether to encode or decode a given file
# using the MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD environment variable.
# Arguments:
# $1 - path to input file which to be encoded/decoded
# $2 - (optional) path to output file in case of decoding
function encode_or_decode() {
    if [ ! -f $1 ]; then
        echo "File '$1' does not exist." 
        return
    fi

    if [ "$CMD" = "encode" ]; then
        # Encoding
        openssl enc \
            -e \
            -aes-256-cbc \
            -pbkdf2 \
            -salt \
            -in $1 \
            -out $1.enc \
            -pass env:MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD
    else
        # Decoding
        echo "Decoding file $1 into $2"
        openssl enc \
            -d \
            -aes-256-cbc \
            -pbkdf2 \
            -in $1 \
            -out $2 \
            -pass env:MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD
    fi
}

function eod_android() {
    if [ "$CMD" = "encode" ]; then
        # Encode android
        encode_or_decode ./android/$ANDROID_KEYSTORE
        encode_or_decode ./android/key_alias.txt
        encode_or_decode ./android/key_password.txt
        encode_or_decode ./android/store_password.txt
    else
        # Decode android
        mkdir -p ./decoded/android
        encode_or_decode ./android/$ANDROID_KEYSTORE.enc ./decoded/android/$ANDROID_KEYSTORE
        encode_or_decode ./android/key_alias.txt.enc ./decoded/android/key_alias.txt
        encode_or_decode ./android/key_password.txt.enc ./decoded/android/key_password.txt
        encode_or_decode ./android/store_password.txt.enc ./decoded/android/store_password.txt
    fi
}

function eod_ios() {
    if [ "$CMD" = "encode" ]; then
        # Encode ios
        encode_or_decode ./ios/$IOS_DISTRIBUTION_CERTIFICATE_P12
        encode_or_decode ./ios/distribution_certificate_password.txt
        encode_or_decode ./ios/keychain_password.txt

        # Encode the provisioning profiles
        for file in "${IOS_PROVISION_PROFILES[@]}"; do
            encode_or_decode "./ios/$file"
        done
    else
        # Decode ios
        mkdir -p ./decoded/ios
        encode_or_decode ./ios/$IOS_DISTRIBUTION_CERTIFICATE_P12.enc ./decoded/ios/$IOS_DISTRIBUTION_CERTIFICATE_P12
        encode_or_decode ./ios/distribution_certificate_password.txt.enc ./decoded/ios/distribution_certificate_password.txt
        encode_or_decode ./ios/keychain_password.txt.enc ./decoded/ios/keychain_password.txt

        # Decode the provisioning profiles
        for file in "${IOS_PROVISION_PROFILES[@]}"; do
            encode_or_decode "./ios/$file.enc" "./decoded/ios/$file"
        done
    fi
}

function eod_android_deploy() {
    if [ "$CMD" = "encode" ]; then
        # Encode deploy_android
        encode_or_decode ./android/$ANDROID_SERVICE_ACCOUNT_KEY
    else
        # Decode deploy_android
        mkdir -p ./decoded/android
        encode_or_decode ./android/$ANDROID_SERVICE_ACCOUNT_KEY.enc ./decoded/android/$ANDROID_SERVICE_ACCOUNT_KEY
    fi
}

function eod_ios_deploy() {
    if [ "$CMD" = "encode" ]; then
        # Encode deploy_ios
        encode_or_decode ./ios/$IOS_AUTH_KEY_P8
    else
        # Decode deploy_ios
        mkdir -p ./decoded/ios
        encode_or_decode ./ios/$IOS_AUTH_KEY_P8.enc ./decoded/ios/$IOS_AUTH_KEY_P8
    fi
}

function eod_firebase() {
    if [ "$CMD" = "encode" ]; then
        # Encode firebase
        encode_or_decode ./firebase/firebase_token.txt
    else
        # Decode firebase
        mkdir -p ./decoded/firebase
        encode_or_decode ./firebase/firebase_token.txt.enc ./decoded/firebase/firebase_token.txt
    fi
}

##########################
 
# Check for argument count
if (( $# < 2 )); then
    echo "Usage: encode|decode <mode> [arguments] . Available modes: $MODES_STR" && exit 2
fi

# Check for valid commands
if ! echo "${AVAILABLE_COMMANDS[@]}" | grep -qw "$CMD"; then
    echo "Invalid command '$CMD'. Available commands: ${AVAILABLE_COMMANDS[@]}" && exit 3
fi

# Check for valid mode
if ! echo "${AVAILABLE_MODES[@]}" | grep -qw "$MODE"; then
    echo "Invalid mode '$MODE'. Available modes: $MODES_STR" && exit 4
fi

# Check for encryption/decryption password
if [ -z "$MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD" ]; then
    echo "Enter the encryption/decryption password: "
    read -r -s PASS
    export MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD=$PASS
fi

# Execute command in a given mode
case $MODE in
    "file")
        if [[ "$CMD" = "encode" && $#<3 ]]; then
            echo "Missing arguments: $CMD file <input>" && exit 5
        elif [[ "$CMD" = "decode" && $#<4 ]]; then
            echo "Missing arguments: $CMD file <input> <output>" && exit 5
        fi
        encode_or_decode $3 $4
        ;;
    "android") eod_android ;;
    "ios") eod_ios ;;
    "deploy_android") eod_android_deploy ;;
    "deploy_ios") eod_ios_deploy ;;
    "firebase") eod_firebase ;;
    "all")
        eod_android
        eod_android_deploy
        eod_ios
        eod_ios_deploy
        eod_firebase
        ;;
esac

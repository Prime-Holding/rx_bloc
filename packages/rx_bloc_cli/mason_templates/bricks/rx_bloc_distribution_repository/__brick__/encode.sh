#!/bin/sh

set -e

if [ -z "$1" ]
then
    echo "No argument supplied"
    exit 2
fi

if [ -z "$MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD" ]; then
    echo "Enter the MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD encryption value: "
    stty -echo
    read -r PASS
    stty echo
    export MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD=$PASS
fi

openssl enc \
    -e \
    -aes-256-cbc \
    -pbkdf2 \
    -salt \
    -in $1 \
    -out $1.enc \
    -pass env:MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD

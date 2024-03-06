#!/bin/sh

set -e

if [ -z ${MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD+x} ];
then
    echo "Error: the MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD environment variable is not set"
    exit 1
fi

if [ -z "$1" ]
then
    echo "No argument supplied"
    exit 2
fi

openssl enc \
    -e \
    -aes-256-cbc \
    -pbkdf2 \
    -salt \
    -in $1 \
    -out $1.enc \
    -pass env:MOBILE_DISTRIBUTION_ENCRYPTION_PASSWORD

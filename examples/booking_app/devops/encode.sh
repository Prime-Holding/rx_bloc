#!/bin/sh

set -e

if [ -z ${flutter_app_mobile_distribution_encryption_password+x} ];
then
    echo "Error: the flutter_app_mobile_distribution_encryption_password environment variable is not set"
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
    -pass env:flutter_app_mobile_distribution_encryption_password

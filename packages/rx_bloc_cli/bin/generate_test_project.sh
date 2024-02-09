#!/usr/bin/env bash

set -e

USAGE="Usage: generate_test_project.sh default|all_enabled|all_disabled|without_showcase_features"
PROJECT_TYPES=("default" "all_enabled" "all_disabled" "without_showcase_features")

if [ $# != 1 ]; then
    echo $USAGE && exit 1
fi

function generate(){
  dirname="testapp"
  rm -rf example/$dirname
  dart run $(dirname "$0")/rx_bloc_cli.dart create \
   --no-interactive \
   --project-name=testapp \
   --organisation=com.primeholding \
   $@ \
   example/$dirname
}

if [ $1 == "default" ]; then
  # Generated project should use default configuration
  generate
fi

if [ $1 == "all_enabled" ]; then
  # Generated project uses all features enabled
  generate --enable-analytics \
  --enable-feature-counter \
  --enable-feature-deeplinks \
  --enable-feature-widget-toolkit \
  --enable-login \
  --enable-social-logins \
  --enable-change-language \
  --enable-dev-menu \
  --enable-patrol \
  --realtime-communication=sse \
  --enable-otp \
  --cicd=github \
  --enable-pin-code \
  --enable-auth-matrix
fi 

if [ $1 == "all_disabled" ]; then
  # Generated project uses all features disabled
  generate --no-enable-analytics \
  --no-enable-feature-counter \
  --no-enable-feature-deeplinks \
  --no-enable-feature-widget-toolkit \
  --no-enable-login \
  --no-enable-social-logins \
  --no-enable-change-language \
  --no-enable-dev-menu \
  --no-enable-patrol \
  --realtime-communication=none \
  --no-enable-otp \
  --cicd=none \
  --no-enable-pin-code \
  --no-enable-auth-matrix
fi 

if [ $1 == "without_showcase_features" ]; then
  # Generated project uses all features enabled except for showcase features
  generate --enable-analytics \
    --enable-login \
    --enable-social-logins \
    --enable-change-language \
    --enable-dev-menu \
    --enable-patrol \
    --realtime-communication=sse \
    --enable-otp \
    --cicd=fastlane \
    --enable-pin-code \
    --enable-auth-matrix \
    --no-enable-feature-counter \
    --no-enable-feature-widget-toolkit \
    --no-enable-feature-deeplinks
fi
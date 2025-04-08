#!/usr/bin/env bash

set -e

if [ $# -lt 1 ]; then
    echo "Usage: generate_test_project.sh <project_type> [output_directory]"
    echo "project_type: default | all_enabled | all_disabled | without_showcase_features"
    echo "output_directory: defaults to <rx_bloc_cli_root>/example/testapp"
    echo ""
    exit 1
fi

project_type=$1
output_directory=$2

if [ -z "$output_directory" ]; then
  output_directory="example/testapp"
fi

function generate(){
  rm -rf "$output_directory"
  dart run "$(dirname "$0")"/rx_bloc_cli.dart create \
   --no-interactive \
   --project-name=testapp \
   --organisation=com.primeholding \
   "$@" \
   "$output_directory"
}

if [ "$project_type" == "default" ]; then
  # Generated project should use default configuration
  generate
fi

if [ "$project_type" == "all_enabled" ]; then
  # Generated project uses all features enabled
  generate --enable-analytics \
  --enable-feature-counter \
  --enable-feature-deeplinks \
  --enable-feature-widget-toolkit \
  --enable-login \
  --enable-social-logins \
  --enable-change-language \
  --enable-remote-translations \
  --enable-dev-menu \
  --enable-patrol \
  --realtime-communication=sse \
  --enable-otp \
  --cicd=github \
  --enable-pin-code \
  --enable-mfa \
  --enable-feature-qr-scanner \
  --enable-profile \
  --enable-feature-onboarding \
  --enable-forgotten-password
fi 

if [ "$project_type" == "all_disabled" ]; then
  # Generated project uses all features disabled
  generate --no-enable-analytics \
  --no-enable-feature-counter \
  --no-enable-feature-deeplinks \
  --no-enable-feature-widget-toolkit \
  --no-enable-login \
  --no-enable-social-logins \
  --no-enable-change-language \
  --no-enable-remote-translations \
  --no-enable-dev-menu \
  --no-enable-patrol \
  --realtime-communication=none \
  --no-enable-otp \
  --cicd=none \
  --no-enable-pin-code \
  --no-enable-mfa \
  --no-enable-feature-qr-scanner \
  --no-enable-profile \
  --no-enable-feature-onboarding \
  --no-enable-forgotten-password
fi

if [ "$project_type" == "without_showcase_features" ]; then
  # Generated project uses all features enabled except for showcase features
  generate --enable-analytics \
    --enable-login \
    --enable-social-logins \
    --enable-change-language \
    --enable-remote-translations \
    --enable-dev-menu \
    --enable-patrol \
    --realtime-communication=sse \
    --enable-otp \
    --cicd=fastlane \
    --enable-pin-code \
    --enable-mfa \
    --enable-profile \
    --no-enable-feature-counter \
    --no-enable-feature-widget-toolkit \
    --no-enable-feature-deeplinks \
    --no-enable-feature-qr-scanner \
    --no-enable-feature-onboarding \
    --no-enable-forgotten-password
fi
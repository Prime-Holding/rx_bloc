#!/usr/bin/env sh
. $(dirname "$0")/compile_bundles.sh
rm -rf example/test_app
mkdir example/test_app
dart run rx_bloc_cli create \
  --project-name=testapp \
  --organisation=com.primeholding \
  --enable-analytics \
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
  --cicd=fastlane \
  --no-interactive \
  example/test_app

# Copy the readme file one level up so that it is visible on the pub.dev page
cp example/test_app/README.md example/

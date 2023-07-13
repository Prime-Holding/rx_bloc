#!/usr/bin/env sh
. $(dirname "$0")/compile_bundles.sh
rm -rf example/test_app
mkdir example/test_app
dart run rx_bloc_cli create \
  --project-name=testapp \
  --organisation=com.primeholding \
  --enable-analytics=true \
  --enable-feature-counter=true \
  --enable-feature-deeplinks=true\
  --enable-feature-widget-toolkit=true \
  --enable-social-logins=true \
  --enable-change-language=true \
  --enable-dev-menu=true \
  --enable-patrol=true \
  --realtime-communication=sse \
  --enable-otp=true \
  --enable-pin-code=true \
  example/test_app

# Copy the readme file one level up so that it is visible on the pub.dev page
cp example/test_app/README.md example/

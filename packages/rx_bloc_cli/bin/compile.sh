#!/usr/bin/env sh
. $(dirname "$0")/compile_bundles.sh
rm -rf example/test_app
mkdir example/test_app
dart run rx_bloc_cli create \
  --project-name=testapp \
  --organisation=com.primeholding \
  --enable-feature-counter=true \
  --enable-feature-deeplinks=true\
  --enable-feature-widget-toolkit=true \
  --enable-social-logins=true \
  example/test_app
cp example/test_app/README.md example/

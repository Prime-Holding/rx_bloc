#!/usr/bin/env sh
. $(dirname "$0")/compile_bundles.sh

rm -rf example/reminderspoc2
mkdir example/reminderspoc2
dart run rx_bloc_cli create \
  --project-name=reminderspoc \
  --organisation=com.primeholding \
  --enable-feature-counter=true \
  --enable-feature-deeplinks=true\
  --enable-feature-widget-toolkit=true \
  --enable-facebook-auth=true \
  ../../../reminderspoc2
cp example/test_app/README.md example/

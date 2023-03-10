#!/usr/bin/env sh
set -e
dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/rx_bloc_base
  dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/feature_counter
  dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/feature_deeplink
rm -rf example/test_app
mkdir example/test_app
dart run rx_bloc_cli create \
  --project-name=test_app \
  --organisation=com.primeholding \
  --enable-feature-counter=false \
  --enable-feature-deeplinks=false\
  example/test_app
cp example/test_app/README.md example/

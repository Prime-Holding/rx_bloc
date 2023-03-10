#!/usr/bin/env sh
set -e
dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/rx_bloc_base
rm -rf example/test_app
mkdir example/test_app
dart run rx_bloc_cli create \
  --project-name=test_app \
  --organisation=com.primeholding \
  --enable-feature-counter=true \
  --enable-feature-widget-toolkit=false \
  example/test_app
cp example/test_app/README.md example/

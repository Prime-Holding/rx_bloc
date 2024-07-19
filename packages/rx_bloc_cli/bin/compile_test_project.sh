#!/usr/bin/env sh

. $(dirname "$0")/compile_bundles.sh
rm -rf example/testapp
rm -rf example/docs

mkdir example/testapp
$(dirname "$0")/generate_test_project.sh all_enabled

# Copy the readme file one level up so that it is visible on the pub.dev page
cp example/testapp/README.md example/

mkdir example/docs
cp example/testapp/docs/continuous_delivery.md example/docs/
cp example/testapp/docs/app_architecture.png example/docs/
cp example/testapp/docs/cicd_diagram.png example/docs/
cp doc/golden_tests.md example/docs/
#!/usr/bin/env sh

. $(dirname "$0")/compile_bundles.sh
rm -rf example/testapp
mkdir example/testapp
$(dirname "$0")/generate_test_project.sh all_enabled

# Copy the readme file one level up so that it is visible on the pub.dev page
cp example/testapp/README.md example/

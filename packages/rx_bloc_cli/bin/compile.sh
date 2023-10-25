#!/usr/bin/env sh

. $(dirname "$0")/compile_bundles.sh
rm -rf example/test_app
mkdir example/test_app
$(dirname "$0")/generate_test_project.sh all_enabled

# Copy the readme file one level up so that it is visible on the pub.dev page
cp example/test_app/README.md example/

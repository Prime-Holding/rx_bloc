#!/bin/bash

##### Functions

## Replaces the contents of the provided file with some predefined values
function replace_file_contents() {
  # Values should be specified in pairs, first being the old string and the second being a new one
  to_replace=(
    "docs/continuous_delivery.md" "https://github.com/Prime-Holding/rx_bloc/blob/master/packages/rx_bloc_cli/example/docs/continuous_delivery.md"
    "docs/golden_tests.md" "https://github.com/Prime-Holding/rx_bloc/blob/master/packages/rx_bloc_cli/example/docs/golden_tests.md"
    "docs/mfa.md" "https://github.com/Prime-Holding/rx_bloc/blob/master/packages/rx_bloc_cli/example/docs/mfa.md"
    "docs/patrol_integration_test.md" "https://github.com/Prime-Holding/rx_bloc/blob/master/packages/rx_bloc_cli/example/docs/patrol_integration_test.md"
    "docs/feature_creation.md" "https://github.com/Prime-Holding/rx_bloc/blob/master/packages/rx_bloc_cli/example/docs/feature_creation.md"
    "docs/onboarding_api_contracts.md" "https://github.com/Prime-Holding/rx_bloc/blob/master/packages/rx_bloc_cli/example/docs/onboarding_api_contracts.md"
  )

  # Iterate over the to_replace array
  for (( i=1; i<${#to_replace[@]}; i+=2 )); do
    old_str="${to_replace[$i]}"
    new_str="${to_replace[$i+1]}"

    # Replace the old string with the new ones in the provided file
    sed -i '' "s|$old_str|$new_str|g" "$1"
  done
}

## Prepares the example directory
function prepare_example_directory() {
  # Copy the readme file one level up so that it is visible on the pub.dev page
  cp example/testapp/README.md example/

  # Recreate the example/docs directory
  rm -rf example/docs
  mkdir example/docs

  # Copy the contents of the generated docs directory one level up
  cp -r example/testapp/docs/ example/docs/

  replace_file_contents "example/README.md"
}

##### Main

. $(dirname "$0")/compile_bundles.sh

rm -rf example/testapp
mkdir example/testapp

$(dirname "$0")/generate_test_project.sh all_enabled

prepare_example_directory

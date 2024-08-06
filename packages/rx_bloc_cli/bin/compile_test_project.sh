#!/bin/bash

##### Functions

## Replaces the contents of the provided file with some predefined values
function replace_file_contents() {
  to_replace=(
    "docs/continuous_delivery.md" "https://github.com/Prime-Holding/rx_bloc/blob/master/packages/rx_bloc_cli/example/docs/continuous_delivery.md"
    "docs/golden_tests.md" "https://github.com/Prime-Holding/rx_bloc/blob/master/packages/rx_bloc_cli/example/docs/golden_tests.md"
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

  rm -rf example/docs
  mkdir example/docs

  cp example/testapp/docs/continuous_delivery.md example/docs/
  cp example/testapp/docs/app_architecture.png example/docs/
  cp example/testapp/docs/cicd_diagram.png example/docs/
  cp example/testapp/docs/golden_tests.md example/docs/

  replace_file_contents "example/README.md"
}

##### Main

. $(dirname "$0")/compile_bundles.sh

rm -rf example/testapp
mkdir example/testapp

$(dirname "$0")/generate_test_project.sh all_enabled

prepare_example_directory

#!/bin/bash

# Define the directory to search
test_directory="test"

# Find test_files ending with _test.dart in the directory and its subdirectories
test_files=$(find "$test_directory" -type f -name '*_test.dart')

# Check if any test_files were found
if [ -n "$test_files" ]; then
    echo "Found _test.dart in $test_directory folder!"
    flutter test --dart-define=CI=true
else
    echo "No _test.dart files were found in $test_directory folder."
fi
#!/bin/bash

# Define the directory to search
base_dir="example/testapp"
search_dir="$base_dir/test"

# Find files ending with _test.dart in the directory and its subdirectories
files=$(find "." -type f -name '*_test.dart')

# Check if any files were found
if [ -n "$files" ]; then
    echo "Found _test.dart files!"
    flutter test
else
    echo "No _test.dart files found."
fi
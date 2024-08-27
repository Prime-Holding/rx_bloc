#!/bin/bash

# Define the directory to search
search_dir="test"

# Find files ending with _test.dart in the directory and its subdirectories
files=$(find "$search_dir" -type f -name '*_test.dart')

# Check if any files were found
if [ -n "$files" ]; then
    echo "Found _test.dart files!"
    flutter test example/testapp
else
    echo "No _test.dart files found in the $search_dir directory."
fi
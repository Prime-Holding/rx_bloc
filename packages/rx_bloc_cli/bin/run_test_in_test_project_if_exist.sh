#!/bin/bash

# Define the directory to search
search_dir="test"

# Find files ending with _test.dart in the directory and its subdirectories
files=$(find "$search_dir" -type f -name '*_test.dart')

# Check if any files were found
if [ -n "$files" ]; then
    echo "Found _test.dart files!"
    flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
    flutter test #$base_dir
else
    echo "No _test.dart files found."
fi
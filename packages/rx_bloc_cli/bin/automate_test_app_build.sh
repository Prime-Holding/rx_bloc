#!/bin/bash

# Create backup of existing project
rm -rf example/testapp_backup
mv example/testapp example/testapp_backup

# Generate a new test project
bin/compile_test_project.sh

# Init the test project as a local git repository
cd example/testapp || exit
git init
git add .
git commit -m "Initial commit"
cd ../..

#!/usr/bin/env sh

. "$(dirname "$0")"/compile_bundles.sh

rm -rf example/distribution_repo
mkdir example/distribution_repo

dart run "$(dirname "$0")"/rx_bloc_cli.dart create_distribution \
   example/distribution_repo

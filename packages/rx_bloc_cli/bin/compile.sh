#!/usr/bin/env sh
pub run mason bundle -t dart mason_templates/bricks/rx_bloc_base
cp rx_bloc_base_bundle.dart lib/src/templates/
rm rx_bloc_base_bundle.dart
pub global activate -s path . --overwrite
rx_bloc_cli create --org com.primeholding --project-name test_app example/test_app
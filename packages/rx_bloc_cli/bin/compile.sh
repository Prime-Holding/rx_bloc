#!/usr/bin/env sh
pub run mason bundle -t dart mason_templates/bricks/rx_bloc_base
cp rx_bloc_base_bundle.dart lib/src/templates/
rm rx_bloc_base_bundle.dart
pub global activate -s path . --overwrite
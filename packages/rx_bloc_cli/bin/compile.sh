#!/usr/bin/env sh
dart pub run mason bundle -t dart mason_templates/bricks/rx_bloc_base
cp rx_bloc_base_bundle.dart lib/src/templates/
rm rx_bloc_base_bundle.dart
dart pub global activate -s path . --overwrite
rm -rf example/test_app
rx_bloc_cli create --org com.primeholding --project-name ccvoiptest --include-analytics true --push-notifications true example/test_app
cd example/test_app
flutter pub get
cp README.md ../
cd ../..
dart format lib
dart format example/test_app

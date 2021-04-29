#!/usr/bin/env sh

dart pub get
flutter analyze lib
dart test --coverage=coverage --exclude-tags=not-tests
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib --packages=.packages
dart run clean_coverage clean --exclusions '**/.g.dart','**repository.dart','**rxb.g.dart' coverage/lcov.info
genhtml -o coverage coverage/lcov.info
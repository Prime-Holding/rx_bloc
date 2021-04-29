#!/bin/sh

flutter test --coverage --exclude-tags=not-tests
flutter pub run remove_from_coverage -f coverage/lcov.info -r '(repository.dart|rxb.g.dart)$'
genhtml -o coverage coverage/lcov.info
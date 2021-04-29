#!/bin/sh

dart test --coverage=coverage --exclude-tags=not-tests
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib --packages=.packages
genhtml -o coverage coverage/lcov.info
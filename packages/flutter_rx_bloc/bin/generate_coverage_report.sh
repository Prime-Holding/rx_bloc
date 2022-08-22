#!/usr/bin/env sh
flutter test --coverage
genhtml -o coverage coverage/lcov.info
open coverage/index.html
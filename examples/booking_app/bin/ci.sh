#!/usr/bin/env sh

echo  "🚀 Starting booking app CI 🚀"
flutter pub get || exit
flutter analyze lib || exit
flutter test --dart-define=CI=true --coverage --exclude-tags=not-tests || exit
flutter pub run clean_coverage clean --exclusions '**/.g.dart','**repository.dart','**rxb.g.dart' coverage/lcov.info
genhtml -o coverage coverage/lcov.info
echo "🚀 🤖 🤖 🤖 🤖 🤖 🤖 🤖 🤖 🤖 🤖🤖 🤖 🤖 🤖 🤖 🤖 🤖 🤖 🚀"

#!/usr/bin/env sh

echo  "🚀 Starting bloc favorites advanced app CI 🚀"
flutter pub get || exit
flutter analyze lib || exit
flutter test --coverage --exclude-tags=not-tests || exit
flutter pub run clean_coverage clean --exclusions '**repository.dart' coverage/lcov.info
genhtml -o coverage coverage/lcov.info
echo "🚀 🤖 🤖 🤖 🤖 🤖 🤖 🤖 🤖 🤖 🤖🤖 🤖 🤖 🤖 🤖 🤖 🤖 🤖 🚀"
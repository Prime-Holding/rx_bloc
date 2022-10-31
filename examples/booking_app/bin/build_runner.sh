#!/usr/bin/env sh

flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
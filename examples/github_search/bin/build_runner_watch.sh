#!/usr/bin/env sh

flutter pub get && flutter pub run build_runner watch --delete-conflicting-outputs

#!/usr/bin/env sh

# NOTE: this script should be executed in fastlane only

if flutter pub deps | grep -q alice ; then flutter pub remove alice; fi

if [ -e lib/lib_dev_menu ]; then rm -r lib/lib_dev_menu; fi
if [ -e lib/main_dev.dart ]; then rm lib/main_dev.dart; fi
if [ -e lib/main_staging.dart ]; then rm lib/main_staging.dart; fi
if [ -e lib/alice_instance.dart ]; then rm lib/alice_instance.dart; fi

sed -i '' '/dependency_overrides:/ ,/      ref: master/d' pubspec.yaml #if there is other dependency overrides than alice replace "dependency_overrides:" with "alice:"
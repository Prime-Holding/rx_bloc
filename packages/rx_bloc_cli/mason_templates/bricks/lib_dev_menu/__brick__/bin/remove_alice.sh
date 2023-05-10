#!/usr/bin/env sh

# NOTE: this script should be executed in fastlane only

if flutter pub deps | grep -q alice ; then flutter pub remove alice; fi

if [ -e lib/lib_dev_menu ]; then rm -r lib/lib_dev_menu; fi
if [ -e lib/main_dev.dart ]; then rm lib/main_dev.dart; fi
if [ -e lib/main_staging.dart ]; then rm lib/main_staging.dart; fi

sed -i '' "/import 'package:alice\/alice.dart'\;/d" lib/base/data_sources/remote/http_clients/api_http_client.dart
sed -i '' '/    Alice alice,/d' lib/base/data_sources/remote/http_clients/api_http_client.dart
sed -i '' '/    alice.getDioInterceptor(),/d' lib/base/data_sources/remote/http_clients/api_http_client.dart
sed -i '' "/import 'package:alice\/alice.dart'\;/d" lib/base/app/{{project_name}}.dart
sed -i '' '/          context.read<Alice>(),/d' lib/base/app/{{project_name}}.dart
sed -i '' "/import 'package:alice\/alice.dart'\;/d" lib/base/di/{{project_name}}_with_dependencies.dart
sed -i '' '/          ..._packages,/d' lib/base/di/{{project_name}}_with_dependencies.dart
sed -i '' '/        Provider<Alice>(/ ,/                )),/d' lib/base/di/{{project_name}}_with_dependencies.dart
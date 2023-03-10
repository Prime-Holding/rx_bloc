dart run mason_cli:mason bundle -t dart mason_templates/bricks/rx_bloc_base ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/feature_counter ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/feature_deeplink ^
& copy rx_bloc_base_bundle.dart lib\src\templates\ ^
& copy feature_counter_bundle.dart lib\src\templates\ ^
& copy feature_deeplink_bundle.dart lib\src\templates\ ^
& del rx_bloc_base_bundle.dart ^
& del feature_counter_bundle.dart ^
& del feature_deeplink_bundle.dart ^
& dart pub global activate -s path . --overwrite ^
& del  -rf example/test_app ^
& rx_bloc_cli create --organisation com.primeholding --project-name test_app ^
--enable-feature-counter false --enable-feature-deeplinks false example/test_app ^
& cd example/test_app
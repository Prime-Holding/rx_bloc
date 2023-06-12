dart run mason_cli:mason bundle -t dart mason_templates/bricks/rx_bloc_base ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/feature_counter ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/feature_deeplink ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/feature_widget_toolkit ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/lib_router ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/lib_permissions ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/lib_auth ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/lib_social_logins ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/lib_change_language ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/lib_dev_menu ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/patrol_integration_tests ^
& dart run mason_cli:mason bundle -t dart mason_templates/bricks/lib_pin_code ^
& move /Y rx_bloc_base_bundle.dart lib\src\templates\ ^
& move /Y feature_counter_bundle.dart lib\src\templates\ ^
& move /Y feature_deeplink_bundle.dart lib\src\templates\ ^
& move /Y feature_widget_toolkit_bundle.dart lib\src\templates\ ^
& move /Y lib_router_bundle.dart lib\src\templates\ ^
& move /Y lib_permissions_bundle.dart lib\src\templates\ ^
& move /Y lib_auth_bundle.dart lib\src\templates\ ^
& move /Y lib_social_logins_bundle.dart lib\src\templates\ ^
& move /Y lib_dev_menu.dart lib\src\templates\ ^
& move /Y lib_change_language_bundle.dart lib\src\templates\ ^
& move /Y patrol_integration_tests_bundle.dart lib\src\templates\ ^
& move /Y lib_pin_code.dart lib\src\templates\ ^
& rmdir /s/q example\test_app\ ^
& dart pub global activate -s path . --overwrite ^
& rx_bloc_cli create ^
--organisation com.primeholding ^
--project-name testapp ^
--enable-feature-counter true ^
--enable-feature-deeplinks true ^
--enable-feature-widget-toolkit true ^
--enable-social-logins true ^
--enable-analytics true ^
--enable-change-language true ^
--enable-dev-menu true ^
--enable-patrol true ^
--realtime-communication sse ^
--enable-pin-code true ^
example/test_app ^
& cd example/test_app

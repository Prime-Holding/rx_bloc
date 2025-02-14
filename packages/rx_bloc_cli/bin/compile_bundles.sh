#!/bin/sh

set -e
dart pub upgrade

##### Functions

# Create a mason bundle from a brick with the same name
create_mason_bundle() {
  dart run mason_cli:mason bundle \
    -t dart \
    -o lib/src/templates/ \
    mason_templates/bricks/"$1"
}

##### Main

create_mason_bundle rx_bloc_base
create_mason_bundle rx_bloc_flavor_config
create_mason_bundle rx_bloc_distribution_repository
create_mason_bundle feature_counter
create_mason_bundle feature_deeplink
create_mason_bundle lib_change_language
create_mason_bundle lib_translations
create_mason_bundle lib_pin_code
create_mason_bundle feature_widget_toolkit
create_mason_bundle lib_router
create_mason_bundle lib_permissions
create_mason_bundle lib_auth
create_mason_bundle feature_login
create_mason_bundle lib_social_logins
create_mason_bundle lib_dev_menu
create_mason_bundle patrol_integration_tests
create_mason_bundle lib_realtime_communication
create_mason_bundle feature_otp
create_mason_bundle feature_cicd_fastlane
create_mason_bundle lib_analytics
create_mason_bundle lib_mfa
create_mason_bundle feature_qr_scanner
create_mason_bundle feature_profile
create_mason_bundle feature_showcase
create_mason_bundle feature_onboarding

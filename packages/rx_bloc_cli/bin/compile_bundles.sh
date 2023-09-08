#!/usr/bin/env sh

set -e
dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/rx_bloc_base

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/feature_counter

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/feature_deeplink

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/lib_change_language

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/feature_widget_toolkit

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/lib_router

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/lib_permissions

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/lib_auth

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/feature_login

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/lib_social_logins

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/lib_dev_menu

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/patrol_integration_tests

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/lib_realtime_communication

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/feature_otp

dart run mason_cli:mason bundle \
  -t dart \
  -o lib/src/templates/ \
  mason_templates/bricks/lib_auth_matrix

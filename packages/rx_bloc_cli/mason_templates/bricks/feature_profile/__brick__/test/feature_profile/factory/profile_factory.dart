import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';{{#enable_in_app_notifications}}
import 'package:{{project_name}}/feature_in_app_notifications/blocs/unread_notifications_bloc.dart';{{/enable_in_app_notifications}}
import 'package:{{project_name}}/feature_profile/blocs/profile_bloc.dart';
import 'package:{{project_name}}/feature_profile/views/profile_page.dart';{{#has_authentication}}
import 'package:{{project_name}}/lib_auth/blocs/user_account_bloc.dart';{{/has_authentication}}{{#enable_pin_code}}
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';{{/enable_pin_code}}{{#has_authentication}}
import '../../base/common_blocs/user_account_bloc_mock.dart';{{/has_authentication}}{{#enable_pin_code}}
import '../../lib_pin_code/views/mocks/pin_biometrics_auth_datasource_mock.dart';
import '../../lib_pin_code/views/mocks/pin_biometrics_local_datasource_mock.dart';{{/enable_pin_code}}
import '../mock/profile_mock.dart'; {{#enable_in_app_notifications}}
import '../mock/unread_notifications_bloc_mock.dart';{{/enable_in_app_notifications}}

/// Change the parameters according the the needs of the test
Widget profileFactory({
  Result<bool>? areNotificationsEnabled,
  bool? isLoading,
  ErrorModel? errors, {{#enable_pin_code}}
  bool? isPinCreated,
  bool showBiometrics = false, {{/enable_pin_code}}
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [  {{#has_authentication}}
           Provider<UserAccountBlocType>.value(
            value: userAccountBlocMockFactory(loggedIn: true),
           ),{{/has_authentication}}
          {{#enable_pin_code}}
          Provider<BiometricsLocalDataSource>.value(
            value: pinBiometricsLocalDataSourceMockFactory(showBiometrics),
          ),
          Provider<PinBiometricsAuthDataSource>.value(
            value: MockBiometricsAuthDataSource(),
          ),

          {{/enable_pin_code}}
          RxBlocProvider<ProfileBlocType>.value(
            value: profileMockFactory(
              areNotificationsEnabled: areNotificationsEnabled,
              isLoading: isLoading,
              errors: errors,
            ),
          ), {{#enable_in_app_notifications}}
          RxBlocProvider<UnreadNotificationsBlocType>.value(
            value: unreadNotificationsBlocMockFactory(),
          ),{{/enable_in_app_notifications}}
        ],
        child: const ProfilePage(),
      ),
    );

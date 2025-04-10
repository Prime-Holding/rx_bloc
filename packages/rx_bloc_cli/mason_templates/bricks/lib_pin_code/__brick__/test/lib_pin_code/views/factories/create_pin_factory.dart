import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/base/models/pin_code/create_pin_model.dart';
import 'package:{{project_name}}/feature_pin_code/services/create_pin_code_service.dart';
import 'package:{{project_name}}/feature_pin_code/views/set_pin_page.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../mock/create_pin_code_service_mock.dart';
import '../mocks/pin_biometrics_auth_datasource_mock.dart';
import '../mocks/pin_biometrics_local_datasource_mock.dart';

Widget createPinFactory({
  String? title,
  bool? showBiometricsButton,
  bool? isPinCreated,
  bool? deleteStoredPinData,
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [
          Provider<CreatePinCodeService>.value(
            value: createPinCodeServiceMockFactory(),
          ),
          Provider<BiometricsLocalDataSource>.value(
            value: pinBiometricsLocalDataSourceMockFactory(
                showBiometricsButton ?? false),
          ),
          Provider<PinBiometricsAuthDataSource>.value(
            value: MockBiometricsAuthDataSource(),
          ),
        ],
        child: SetPinPage(
          pinModel: CreatePinSetModel(),
        ),
      ),
    );

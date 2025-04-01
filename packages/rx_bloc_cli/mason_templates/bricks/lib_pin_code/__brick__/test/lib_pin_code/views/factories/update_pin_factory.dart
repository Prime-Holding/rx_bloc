import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/feature_pin_code/models/update_pin_model.dart';
import 'package:{{project_name}}/feature_pin_code/services/update_pin_code_service.dart';
import 'package:{{project_name}}/feature_pin_code/views/update_pin_page.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../mock/update_pin_code_service_mock.dart';
import '../mocks/pin_biometrics_auth_datasource_mock.dart';
import '../mocks/pin_biometrics_local_datasource_mock.dart';

Widget updatePinFactory({
  String? title,
  bool showBiometricsButton = false,
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [
          Provider<UpdatePinCodeService>.value(
            value: updatePinCodeServiceMockFactory(
              showBiometricsButton: showBiometricsButton,
            ),
          ),
          Provider<BiometricsLocalDataSource>.value(
            value:
                pinBiometricsLocalDataSourceMockFactory(showBiometricsButton),
          ),
          Provider<PinBiometricsAuthDataSource>.value(
            value: MockBiometricsAuthDataSource(
              showBiometricsButton: showBiometricsButton,
            ),
          ),
        ],
        child: UpdatePinPage(
          pinModel: UpdatePinSetModel(
            token: 'token',
          ),
        ),
      ),
    );

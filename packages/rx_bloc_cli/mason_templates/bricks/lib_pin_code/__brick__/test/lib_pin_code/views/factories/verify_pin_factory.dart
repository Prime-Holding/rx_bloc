import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/feature_pin_code/services/verify_pin_code_service.dart';
import 'package:{{project_name}}/feature_pin_code/views/verify_pin_code_page.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../mock/verify_pin_code_service_mock.dart';
import '../mocks/pin_biometrics_auth_datasource_mock.dart';
import '../mocks/pin_biometrics_local_datasource_mock.dart';

Widget verifyPinFactory({
  String? title,
  bool showBiometricsButton = false,
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [
          Provider<VerifyPinCodeService>.value(
            value: verifyPinCodeServiceMockFactory(
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
        child: VerifyPinCodePage(),
      ),
    );

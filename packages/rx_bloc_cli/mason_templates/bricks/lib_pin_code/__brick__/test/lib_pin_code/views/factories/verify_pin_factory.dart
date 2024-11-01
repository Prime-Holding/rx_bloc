import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/lib_pin_code/bloc/update_and_verify_pin_bloc.dart';
import 'package:{{project_name}}/lib_pin_code/models/pin_code_arguments.dart';
import 'package:{{project_name}}/lib_pin_code/services/verify_pin_code_service.dart';
import 'package:{{project_name}}/lib_pin_code/views/verify_pin_code_page.dart';
import 'package:{{project_name}}/lib_router/blocs/router_bloc.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../../base/common_blocs/router_bloc_mock.dart';
import '../../mock/verify_pin_code_service_mock.dart';
import '../mocks/pin_biometrics_auth_datasource_mock.dart';
import '../mocks/pin_biometrics_local_datasource_mock.dart';
import '../mocks/update_and_verify_pin_bloc_mock.dart';

Widget verifyPinFactory({
  String? title,
  bool showBiometricsButton = false,
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [
          RxBlocProvider<UpdateAndVerifyPinBlocType>.value(
            value: updateAndVerifyPinMockFactory(),
          ),
          RxBlocProvider<RouterBlocType>.value(
            value: routerBlocMockFactory(),
          ),
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
        child: VerifyPinCodePage(
          pinCodeArguments: PinCodeArguments(
            title: title ?? '',
            showBiometricsButton: showBiometricsButton,
          ),
        ),
      ),
    );

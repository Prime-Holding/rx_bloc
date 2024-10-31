import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/lib_pin_code/bloc/create_pin_bloc.dart';
import 'package:{{project_name}}/lib_pin_code/models/pin_code_arguments.dart';
import 'package:{{project_name}}/lib_pin_code/services/create_pin_code_service.dart';
import 'package:{{project_name}}/lib_pin_code/views/create_pin_page.dart';
import 'package:{{project_name}}/lib_router/blocs/router_bloc.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../../base/common_blocs/router_bloc_mock.dart';
import '../../mock/create_pin_code_service_mock.dart';
import '../mocks/create_pin_bloc_mock.dart';
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
          RxBlocProvider<CreatePinBlocType>.value(
            value: createPinMockFactory(
                isPinCreated: isPinCreated,
                deleteStoredPinData: deleteStoredPinData),
          ),
          RxBlocProvider<RouterBlocType>.value(
            value: routerBlocMockFactory(),
          ),
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
        child: CreatePinPage(
          pinCodeArguments: PinCodeArguments(
            title: title ?? '',
          ),
        ),
      ),
    );

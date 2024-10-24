import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/base/common_blocs/coordinator_bloc.dart';
import 'package:{{project_name}}/lib_pin_code/bloc/update_and_verify_pin_bloc.dart';
import 'package:{{project_name}}/lib_pin_code/models/pin_code_arguments.dart';
import 'package:{{project_name}}/lib_pin_code/services/update_pin_code_service.dart';
import 'package:{{project_name}}/lib_pin_code/views/update_pin_page.dart';
import 'package:{{project_name}}/lib_router/blocs/router_bloc.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';

import '../../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../../base/common_blocs/router_bloc_mock.dart';
import '../../mock/update_pin_code_service_mock.dart';
import '../mocks/pin_biometrics_local_datasource_mock.dart';
import '../mocks/update_and_verify_pin_bloc_mock.dart';

Widget updatePinFactory({
  String? title,
  bool? showBiometricsButton,
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [
          RxBlocProvider<UpdateAndVerifyPinBlocType>.value(
            value: updateAndVerifyPinMockFactory(),
          ),
          RxBlocProvider<CoordinatorBlocType>.value(
              value: coordinatorBlocMockFactory()),
          RxBlocProvider<RouterBlocType>.value(
            value: routerBlocMockFactory(),
          ),
          Provider<UpdatePinCodeService>.value(
            value: updatePinCodeServiceMockFactory(),
          ),
          Provider<BiometricsLocalDataSource>.value(
            value: pinBiometricsLocalDataSourceMockFactory(showBiometricsButton ?? false),
          ),
        ],
        child: Builder(builder: (context) {
          if (title != null) {
            PinCodeArguments pinCodeArguments;

            if (showBiometricsButton != null) {
              pinCodeArguments = PinCodeArguments(
                title: title,
                showBiometricsButton: showBiometricsButton,
              );
            } else {
              pinCodeArguments = PinCodeArguments(
                title: title,
              );
            }

            return UpdatePinPage(pinCodeArguments: pinCodeArguments);
          } else {
            return const UpdatePinPage();
          }
        }),
      ),
    );

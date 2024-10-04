import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/lib_pin_code/bloc/create_pin_bloc.dart';
import 'package:{{project_name}}/lib_pin_code/models/pin_code_arguments.dart';
import 'package:{{project_name}}/lib_pin_code/services/create_pin_code_service.dart';
import 'package:{{project_name}}/lib_pin_code/views/create_pin_page.dart';
import 'package:{{project_name}}/lib_router/blocs/router_bloc.dart';

import '../../../base/common_blocs/router_bloc_mock.dart';
import '../mocks/create_pin_mock.dart';
import '../mocks/create_pin_service_mock.dart';

/// Change the parameters according the the needs of the test
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
            value: createPinServiceMockFactory(),
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

            return CreatePinPage(pinCodeArguments: pinCodeArguments);
          } else {
            return const CreatePinPage();
          }
        }),
      ),
    );

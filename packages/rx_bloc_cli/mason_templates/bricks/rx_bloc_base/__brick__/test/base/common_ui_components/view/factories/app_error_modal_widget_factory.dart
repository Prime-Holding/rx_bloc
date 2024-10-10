import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:{{project_name}}/base/common_ui_components/app_error_modal_widget.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';

import '../mocks/app_error_modal_widget_mock.dart';

Widget appErrorModalWidgetFactory({
  required ErrorModel error,
}) =>
    Scaffold(
      body: MultiProvider(
        providers: [
          RxBlocProvider<RxBlocTypeBase>.value(
            value: appErrorModalWidgetMockFactory(),
          ),
        ],
        child: AppErrorModalWidget(
          errorState: (bloc) => Stream.value(error),
        ),
      ),
    );

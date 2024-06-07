// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:widget_toolkit/widget_toolkit.dart' hide ErrorModel;

import '../extensions/error_model_translations.dart';
import '../models/errors/error_model.dart';

typedef ErrorStateCallback<BlocType extends RxBlocTypeBase> = Stream<ErrorModel>
    Function(BlocType bloc);

class AppErrorModalWidget<BlocType extends RxBlocTypeBase>
    extends StatelessWidget {
  const AppErrorModalWidget({
    required this.errorState,
    super.key,
  });

  final ErrorStateCallback<BlocType> errorState;

  @override
  Widget build(BuildContext context) => RxBlocListener<BlocType, ErrorModel>(
        state: (bloc) => errorState(bloc),
        listener: (context, error) => showBlurredBottomSheet(
          context: context,
          builder: (BuildContext context) => MessagePanelWidget(
            message: error.translate(context),
            messageState: MessagePanelState.neutral,
          ),
        ),
      );
}

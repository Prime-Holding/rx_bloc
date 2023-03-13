{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:widget_toolkit/widget_toolkit.dart' hide ErrorModel;

import '../../app_extensions.dart';
import '../extensions/error_model_translations.dart';
import '../models/errors/error_model.dart';

typedef ErrorStateCallback<BlocType extends RxBlocTypeBase> = Stream<ErrorModel>
    Function(BlocType bloc);

class AppErrorModalWidget<BlocType extends RxBlocTypeBase>
    extends StatelessWidget {
  const AppErrorModalWidget({
    required this.errorState,
    Key? key,
  }) : super(key: key);

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

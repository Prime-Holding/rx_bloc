{{> licence.dart }}

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
    this.onRetry,
    this.onCancel,
    super.key,
  });

  final ErrorStateCallback<BlocType> errorState;
  final Function(BuildContext, ErrorModel)? onRetry;
  final Function()? onCancel;

  @override
  Widget build(BuildContext context) => RxBlocListener<BlocType, ErrorModel>(
        state: (bloc) => errorState(bloc),
        listener: (context, error) => onRetry != null
            ? showErrorBlurredBottomSheet(
                context: context,
                error: error.translate(context),
                configuration: const ModalConfiguration(showCloseButton: true),
                retryCallback: (context) => onRetry?.call(context, error),
                onCancelCallback: onCancel,
              )
            : showBlurredBottomSheet(
                context: context,
                builder: (BuildContext context) => MessagePanelWidget(
                message: error.translate(context),
                messageState: MessagePanelState.neutral,
                ),
              ),
        );
}

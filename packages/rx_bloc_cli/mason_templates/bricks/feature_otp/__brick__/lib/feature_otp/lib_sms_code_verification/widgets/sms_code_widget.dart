import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../../base/models/errors/error_model.dart';
import '../../../base/models/temporary_code_state.dart';
import '../bloc/sms_code_bloc.dart';

/// SmsCodeWidget is a wrapper widget which provides all the necessary
/// dependencies for the SmsCodeBloc which will be accessible for the underlying
/// [builder] widget.
class SmsCodeWidget extends StatelessWidget {
  const SmsCodeWidget({
    required this.builder,
    this.onError,
    this.onResult,
    super.key,
  });

  /// The child widget [builder]
  final Widget Function(TemporaryCodeState? codeState) builder;
  final void Function(BuildContext, ErrorModel?)? onError;
  final void Function(BuildContext, dynamic)? onResult;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RxBlocListener<SmsCodeBlocType, ErrorModel?>(
              listener: (context, error) => onError?.call(context, error),
              state: (bloc) => bloc.states.errors),
          RxBlocListener<SmsCodeBlocType, dynamic>(
              listener: (context, result) => onResult?.call(context, result),
              state: (bloc) => bloc.states.result),
          Flexible(
            child: RxBlocBuilder<SmsCodeBlocType, TemporaryCodeState>(
              state: (bloc) => bloc.states.onCodeVerificationResult,
              builder: (context, codeState, bloc) => builder(codeState.data),
            ),
          ),
        ],
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../base/models/errors/error_model.dart';
import '../../../base/models/temporary_code_state.dart';
import '../../lib_countdown_widget/services/countdown_service.dart';
import '../../lib_countdown_widget/services/countdown_service_impl.dart';
import '../bloc/sms_code_bloc.dart';
import '../services/sms_code_service.dart';
import '../widgets/sms_code_widget.dart';

/// Sms Code dependencies that the SmsCodeWidget requires in order to
/// perform properly. Includes the bloc containing the states and events to
/// which the SmsCodeWidget can react to or manipulate.
class SmsCodeProvider extends StatelessWidget {
  const SmsCodeProvider({
    required this.smsCodeService,
    required this.sentNewCodeActivationTime,
    required this.builder,
    this.countdownService,
    this.initialPhoneNumber,
    this.onError,
    this.onResult,
    super.key,
  });

  final SmsCodeService smsCodeService;
  final CountdownService? countdownService;
  final String? initialPhoneNumber;
  final int sentNewCodeActivationTime;

  final Widget Function(TemporaryCodeState? codeState) builder;
  final void Function(BuildContext, ErrorModel?)? onError;
  final void Function(BuildContext, dynamic)? onResult;

  List<SingleChildWidget> get _blocs => [
        RxBlocProvider<SmsCodeBlocType>(
          create: (context) => SmsCodeBloc(context.read(),
              service: smsCodeService,
              countdownService: countdownService ?? CountdownServiceImpl(),
              initialPhoneNumber: initialPhoneNumber,
              sentNewCodeActivationTime: sentNewCodeActivationTime),
        ),
      ];

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [..._blocs],
        child: SmsCodeWidget(
          builder: builder,
          onError: onError,
          onResult: onResult,
        ),
      );
}

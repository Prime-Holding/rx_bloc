import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../base/models/errors/error_model.dart';
import '../blocs/onboarding_phone_bloc.dart';

/// Widget that listens to the errors of the [OnboardingPhoneBloc]
/// and shows a [showErrorBlurredBottomSheet] with the error message.
class OnboardingErrorListener extends StatelessWidget {
  const OnboardingErrorListener({super.key});

  @override
  Widget build(BuildContext context) =>
      RxBlocListener<OnboardingPhoneBlocType, ErrorModel>(
        state: (bloc) => bloc.states.errors,
        listener: (context, error) => showErrorBlurredBottomSheet(
          context: context,
          error: _translateError(context, error),
        ),
      );

  String _translateError(BuildContext context, Exception exception) {
    if (exception is BadRequestErrorModel && exception.message != null) {
      return exception.message!;
    }
    return exception.toString();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../../lib_auth_matrix/bloc/auth_matrix_bloc.dart';
import '../services/auth_matrix_text_field_service.dart';

class AuthMatrixPage extends StatelessWidget {
  const AuthMatrixPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.featureAuthMatrix.authMatrixAppBarTitle),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RxBlocListener<AuthMatrixBlocType, void>(
              state: (bloc) => bloc.states.response,
              listener: (context, _) => _onResponse(context),
            ),
            AppErrorModalWidget<AuthMatrixBlocType>(
              errorState: (bloc) => bloc.states.errors.translate(context),
            ),
            Padding(
              padding: EdgeInsets.all(context.designSystem.spacing.xl),
              child: TextFieldDialog<String>(
                translateError: (error) =>
                    ErrorModelFieldL10n.translateError<String>(error, context),
                label: context.l10n.featureAuthMatrix.fieldMessageLabel,
                emptyLabel: context.l10n.featureAuthMatrix.fieldHintMessage,
                validator: context.read<AuthMatrixTextFieldService>(),
                header: context.l10n.featureAuthMatrix.fieldHintMessage,
                onChanged: (value) =>
                    context.read<AuthMatrixBlocType>().events.userData(value),
                fillButtonText: context.l10n.featureAuthMatrix.fillButtonText,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.designSystem.spacing.xl),
              child: RxBlocBuilder<AuthMatrixBlocType, String?>(
                state: (bloc) => bloc.states.textFieldValue,
                builder: (context, textFieldValue, bloc) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientFillButton(
                      onPressed: (textFieldValue.hasData)
                          ? bloc.events.submitPinBiometrics
                          : null,
                      text: context.l10n.featureAuthMatrix.pinBiometrics,
                      state: textFieldValue.data != null
                          ? ButtonStateModel.enabled
                          : ButtonStateModel.disabled,
                    ),
                    SizedBox(
                      height: context.designSystem.spacing.s0,
                    ),
                    GradientFillButton(
                      onPressed: (textFieldValue.hasData)
                          ? bloc.events.submitOtp
                          : null,
                      text: context.l10n.featureAuthMatrix.otp,
                      state: textFieldValue.data != null
                          ? ButtonStateModel.enabled
                          : ButtonStateModel.disabled,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  void _onResponse(BuildContext context) => showBlurredBottomSheet(
        context: context,
        builder: (BuildContext context) => MessagePanelWidget(
            message: context.l10n.featureAuthMatrix.authMatrixSuccess,
            messageState: MessagePanelState.positiveCheck),
      );
}

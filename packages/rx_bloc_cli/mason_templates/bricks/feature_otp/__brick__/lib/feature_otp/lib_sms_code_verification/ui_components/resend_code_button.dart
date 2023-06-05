import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../../app_extensions.dart';
import '../../../base/models/temporary_code_state.dart';
import '../bloc/sms_code_bloc.dart';

class ResendCodeButton extends StatelessWidget {
  const ResendCodeButton(
      {this.label,
      this.onPressed,
      this.textStyle,
      this.buttonColorStyle,
      this.activeStateIcon,
      this.pressedStateIcon,
      this.disabledStateIcon,
      this.loadingStateIcon,
      this.capitalizeLabels = true,
      this.splashEffectEnabled = false,
      this.useInternalCommunication = true,
      this.state = ButtonStateModel.enabled,
      Key? key})
      : assert(
            activeStateIcon is IconData ||
                activeStateIcon is Widget ||
                activeStateIcon == null,
            'Provide Widget, IconData or null for activeStateIcon.'),
        assert(
            loadingStateIcon is IconData ||
                loadingStateIcon is Widget ||
                loadingStateIcon == null,
            'Provide Widget, IconData or null for loadingStateIcon.'),
        assert(
            pressedStateIcon is IconData ||
                pressedStateIcon is Widget ||
                pressedStateIcon == null,
            'Provide Widget, IconData or null for codeSentStateIcon.'),
        assert(
            disabledStateIcon is IconData ||
                disabledStateIcon is Widget ||
                disabledStateIcon == null,
            'Provide Widget, IconData or null for errorStateIcon.'),
        super(key: key);
  final String? label;

  final void Function()? onPressed;

  /// Enable splash effect on the button
  final bool splashEffectEnabled;

  /// Use this to provide a custom textStyle for button labels
  final TextStyle? textStyle;

  /// The style of the button
  final ButtonColorStyle? buttonColorStyle;

  /// If button labels will be capitalized, defaults to true
  final bool capitalizeLabels;

  /// Provide an IconData or other widget
  final dynamic activeStateIcon;

  /// Provide an IconData or other widget
  final dynamic loadingStateIcon;

  /// Provide an IconData or other widget
  final dynamic pressedStateIcon;

  /// Provide an IconData or other widget
  final dynamic disabledStateIcon;

  final bool useInternalCommunication;

  final ButtonStateModel state;

  @override
  Widget build(BuildContext context) => useInternalCommunication
      ? _buildWithDependencies(context)
      : _buildResendButton(
          context,
          label: label ?? context.l10n.featureOtp.resendButtonActiveStateLabel,
          onPressed: onPressed,
          currentState: state,
          activeStateIcon: activeStateIcon,
          loadingStateIcon: loadingStateIcon,
          pressedStateIcon: pressedStateIcon,
          disabledStateIcon: disabledStateIcon,
        );

  Widget _buildWithDependencies(BuildContext context) =>
      RxBlocBuilder<SmsCodeBlocType, TemporaryCodeState>(
        state: (bloc) => bloc.states.onCodeVerificationResult,
        builder: (context, codeState, bloc) {
          ButtonStateModel? globalState = (codeState.hasData &&
                  codeState.data == TemporaryCodeState.correct)
              ? ButtonStateModel.disabled
              : null;

          return RxResultBuilder<SmsCodeBlocType, bool>(
            state: (bloc) => bloc.states.isSendNewCodeEnabled,

            buildSuccess: (context, isEnabled, bloc) =>
                RxBlocBuilder<SmsCodeBlocType, bool>(
              state: (bloc) => bloc.states.sentNewCode,
              builder: (context, isSent, bloc) => (isSent.hasData &&
                      isSent.data!)
                  ? _buildResendButton(
                      context,
                      onPressed: onPressed,
                      label: context.l10n.featureOtp.codeSent,
                      pressedStateIcon: pressedStateIcon ??
                          Icons.check_circle_outline_rounded,
                      textColor: context.designSystem.colors.pinBgSuccessColor,
                      iconColor:
                          context.designSystem.colors.pinSuccessBorderColor,
                      currentState: globalState ?? ButtonStateModel.pressed,
                    )
                  : _buildResendButton(
                      context,
                      onPressed: () {
                        context.read<SmsCodeBlocType>().events.sendNewCode();
                        onPressed?.call();
                      },
                      label: context.l10n.featureOtp.sendNewCode,
                      activeStateIcon: activeStateIcon ?? Icons.send_outlined,
                      disabledStateIcon:
                          (disabledStateIcon ?? Icons.send_outlined),
                      textColor: isEnabled
                          ? context.widgetToolkitTheme.buttonTextColor
                          : context
                              .widgetToolkitTheme.textButtonTextColorDisabled,
                      iconColor: (globalState != ButtonStateModel.disabled &&
                              isEnabled)
                          ? context.widgetToolkitTheme.buttonTextColor
                          : context
                              .widgetToolkitTheme.textButtonTextColorDisabled,
                      currentState: globalState ??
                          (isEnabled
                              ? ButtonStateModel.enabled
                              : ButtonStateModel.disabled),
                    ),
            ),

            buildLoading: (context, bloc) => _buildResendButton(context,
                onPressed: null,
                label: context.l10n.featureOtp.sendNewCode,
                textColor:
                    context.widgetToolkitTheme.textButtonTextColorDisabled,
                currentState: globalState ?? ButtonStateModel.loading,
                loadingStateIcon: (loadingStateIcon ?? Icons.refresh),
                iconColor:
                    context.widgetToolkitTheme.textButtonTextColorDisabled),

            buildError: (context, error, bloc) => _buildResendButton(
              context,
              onPressed: () {
                context.read<SmsCodeBlocType>().events.sendNewCode();
                onPressed?.call();
              },
              label: context.l10n.featureOtp.smsCodeResendError,
              iconColor: context.widgetToolkitTheme.errorCardIconColor,
              activeStateIcon: activeStateIcon ?? Icons.refresh,
              textColor: context.widgetToolkitTheme.errorCardTextColor,
              currentState: globalState ?? ButtonStateModel.enabled,
            ),
            // ),
          );
        },
      );

  Widget _buildResendButton(
    BuildContext context, {
    required String label,
    void Function()? onPressed,
    Color? textColor,
    Color? iconColor,
    required ButtonStateModel currentState,
    dynamic activeStateIcon,
    dynamic loadingStateIcon,
    dynamic pressedStateIcon,
    dynamic disabledStateIcon,
  }) =>
      IconTextButton(
          splashEffectEnabled: splashEffectEnabled,
          state: currentState,
          iconColor: iconColor,
          icon: currentState == ButtonStateModel.loading
              ? (loadingStateIcon ??
                  SizedLoadingIndicator(
                    color: textColor,
                    padding: EdgeInsets.zero,
                    size: const Size(
                      10,
                      10,
                    ),
                    strokeWidth: 3,
                  ))
              : currentState == ButtonStateModel.pressed
                  ? pressedStateIcon
                  : currentState == ButtonStateModel.enabled
                      ? activeStateIcon
                      : currentState == ButtonStateModel.disabled
                          ? disabledStateIcon
                          : activeStateIcon,
          colorStyle: buttonColorStyle ??
              ButtonColorStyle.fromContext(
                context,
                activeGradientColorStart: Colors.transparent,
                activeButtonTextColor: context.designSystem.colors.primaryColor,
                disabledButtonTextColor: context.designSystem.colors.gray,
                pressedColor: Colors.transparent,
              ),
          onPressed: () => onPressed?.call(),
          text: capitalizeLabels ? label.toUpperCase() : label,
          textStyle:
              textStyle ?? context.designSystem.typography.otpResendButtonText);
}

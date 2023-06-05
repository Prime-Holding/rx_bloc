import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/theme_data.dart';

import '../../../base/utils/feature_otp_utils/enums.dart' as enums;
import '../../app_extensions.dart';
import '../../base/models/temporary_code_state.dart';
import '../lib_sms_code_verification/bloc/sms_code_bloc.dart';
import 'sms_code_theme_configuration.dart';

/// SMS code field with a lot of customization also supporting sms code
/// autofill and paste functionality.
class SmsCodeField extends StatefulWidget {
// class SmsCodeField extends StatelessWidget {
  const SmsCodeField({
    this.onChanged,
    this.onSubmitted,
    this.onCompleted,
    this.onFieldTap,
    this.controller,
    this.focusNode,
    this.validator,
    this.cursor,
    this.errorText,
    this.errorBuilder,
    this.prefilledWidget,
    this.obscuringWidget,
    this.separator = const SizedBox(width: 8),
    this.senderPhoneNumber,
    this.pinLength = 4,
    this.enabled,
    this.readOnly = false,
    this.autofocus = false,
    this.showCursor = true,
    this.obscureText = false,
    this.autoValidate = true,
    this.forceErrorState = false,
    this.closeKeyboardOnDone = true,
    this.keyboardType = TextInputType.number,
    this.pinContentAlignment = Alignment.center,
    this.themeConfig = const SmsThemeConfiguration(),
    this.inputAnimationType = enums.PinAnimationType.scale,
    this.hapticFeedbackType = enums.HapticFeedbackType.disabled,
    this.androidSmsAutofillMethod = enums.AndroidSmsAutofillMethod.none,
    this.useInternalCommunication = true,
    super.key,
  });

  /// The number of pin fields
  final int pinLength;

  /// If the field readonly
  final bool readOnly;

  /// Should the field be autofocused
  final bool autofocus;

  /// Focus node for custom focus control
  final FocusNode? focusNode;

  /// Callback executed once a change has been detected
  final void Function(String)? onChanged;

  /// Callback executed once the input has been submitted via the keyboard
  final void Function(String)? onSubmitted;

  /// Callback executed once the last pin character has been entered
  final void Function(String)? onCompleted;

  /// Callback executed once the field has been tapped
  final void Function()? onFieldTap;

  /// Pin field controller
  final TextEditingController? controller;

  /// Hide text input
  final bool obscureText;

  /// Widget used to hide the input
  final Widget? obscuringWidget;

  /// Widget displayed while the field is not yet filled
  final Widget? prefilledWidget;

  /// Should the sms field auto-validate after all the fields are submitted
  final bool autoValidate;

  /// Input validator callback called once all pin fields have been filled. If
  /// the callback returns `null` the input validation is successful. Any string
  /// returned from this callback will be displayed as a validation error.
  final String? Function(BuildContext, String?)? validator;

  /// Toggles the visibility of the [cursor] widget
  final bool showCursor;

  /// Custom [cursor] widget
  final Widget? cursor;

  /// Alignment of the content inside the pin fields
  final AlignmentGeometry pinContentAlignment;

  /// Text input type
  final TextInputType keyboardType;

  /// Optional parameter for Android SMS User Consent API.
  final String? senderPhoneNumber;

  /// Should the keyboard be closed once all the fields have been submitted
  final bool closeKeyboardOnDone;

  /// By default Android autofill is Disabled, you can enable it by using any of options listed below
  ///
  /// First option is [AndroidSmsAutofillMethod.smsRetrieverApi] it automatically reads sms without user interaction
  /// More about Sms Retriever API https://developers.google.com/identity/sms-retriever/overview?hl=en
  ///
  /// Second option requires user interaction to confirm reading a SMS, See readme for more details
  /// [AndroidSmsAutofillMethod.smsUserConsentApi]
  /// More about SMS User Consent API https://developers.google.com/identity/sms-retriever/user-consent/overview
  final enums.AndroidSmsAutofillMethod androidSmsAutofillMethod;

  /// Haptic feedback triggered every key press
  final enums.HapticFeedbackType hapticFeedbackType;

  /// Animation type of the input
  final enums.PinAnimationType inputAnimationType;

  /// Error displayed below the pin field. This field is ignored if
  /// [useInternalCommunication] is set to `true`.
  final String? errorText;

  /// Force trigger the error state of the pin field. The field is ignored if
  /// [useInternalCommunication] is set to `true`.
  final bool forceErrorState;

  /// Error builder accepting the error as the first parameter and the pin as
  /// the second parameter
  final Widget Function(String? errorText, String pin)? errorBuilder;

  /// Configuration containing themes for different states of the pin field
  final SmsThemeConfiguration themeConfig;

  /// Widget which will render between the pin fields
  final Widget? separator;

  /// Is the pin field enabled
  final bool? enabled;

  /// Allow the communication between components of the Prime SMS Package. If
  /// this field is set to `true`, the widget will perform a lookup up the
  /// widget tree. If the SmsCodeBlocType bloc is not part of the widget tree,
  /// the
  final bool useInternalCommunication;

  @override
  State<SmsCodeField> createState() => _SmsCodeFieldState();
}

class _SmsCodeFieldState extends State<SmsCodeField> {
  TextEditingController? _controller;

  @override
  void initState() {
    _controller = widget.controller;

    super.initState();
  }

  AndroidSmsAutofillMethod get _smsAutofillMethod {
    switch (widget.androidSmsAutofillMethod) {
      case enums.AndroidSmsAutofillMethod.none:
        return AndroidSmsAutofillMethod.none;
      case enums.AndroidSmsAutofillMethod.smsRetrieverApi:
        return AndroidSmsAutofillMethod.smsRetrieverApi;
      case enums.AndroidSmsAutofillMethod.smsUserConsentApi:
        return AndroidSmsAutofillMethod.smsUserConsentApi;
    }
  }

  PinAnimationType get _animationType {
    switch (widget.inputAnimationType) {
      case enums.PinAnimationType.rotation:
        return PinAnimationType.rotation;
      case enums.PinAnimationType.none:
        return PinAnimationType.none;
      case enums.PinAnimationType.scale:
        return PinAnimationType.scale;
      case enums.PinAnimationType.fade:
        return PinAnimationType.fade;
      case enums.PinAnimationType.slide:
        return PinAnimationType.slide;
    }
  }

  HapticFeedbackType get _hapticFeedbackType {
    switch (widget.hapticFeedbackType) {
      case enums.HapticFeedbackType.disabled:
        return HapticFeedbackType.disabled;
      case enums.HapticFeedbackType.lightImpact:
        return HapticFeedbackType.lightImpact;
      case enums.HapticFeedbackType.mediumImpact:
        return HapticFeedbackType.mediumImpact;
      case enums.HapticFeedbackType.heavyImpact:
        return HapticFeedbackType.heavyImpact;
      case enums.HapticFeedbackType.selectionClick:
        return HapticFeedbackType.selectionClick;
      case enums.HapticFeedbackType.vibrate:
        return HapticFeedbackType.vibrate;
    }
  }

  @override
  Widget build(BuildContext context) => widget.useInternalCommunication
      ? _buildPinFieldWithBuilder(context)
      : _buildPinField(context,
          forceErrorState: widget.forceErrorState,
          errorText: widget.errorText,
          pinLength: widget.pinLength,
          enabled: widget.enabled ?? true,
          onCompleted: widget.onCompleted);

  /// region Builders

  /// Widget built if [widget.useInternalCommunication] is disabled
  Widget _buildPinField(
    BuildContext context, {
    String? errorText,
    bool forceErrorState = false,
    bool forceSuccessState = false,
    bool enabled = true,
    required int pinLength,
    void Function(String)? onCompleted,
    bool readOnly = false,
  }) =>
      Pinput(
        defaultPinTheme: _buildDefaultTheme(context),
        errorPinTheme: _buildErrorTheme(context),
        disabledPinTheme: forceSuccessState
            ? _buildSuccessTheme(context)
            : _buildDisabledTheme(context),
        focusedPinTheme: _buildFocusedTheme(context),
        submittedPinTheme: _buildSubmittedTheme(context),
        followingPinTheme: _buildUnfilledStyleTheme(context),
        androidSmsAutofillMethod: _smsAutofillMethod,
        hapticFeedbackType: _hapticFeedbackType,
        pinAnimationType: _animationType,
        preFilledWidget: widget.prefilledWidget,
        keyboardType: widget.keyboardType,
        controller: _controller,
        length: pinLength,
        readOnly: readOnly,
        autofocus: widget.autofocus,
        focusNode: widget.focusNode,
        showCursor: widget.showCursor,
        enabled: enabled,
        errorText: errorText,
        onTap: widget.onFieldTap,
        onChanged: widget.onChanged,
        onCompleted: onCompleted,
        onSubmitted: widget.onSubmitted,
        obscureText: widget.obscureText,
        obscuringWidget: widget.obscuringWidget,
        senderPhoneNumber: widget.senderPhoneNumber,
        pinContentAlignment: widget.pinContentAlignment,
        errorBuilder: widget.errorBuilder,
        forceErrorState: forceErrorState,
        closeKeyboardWhenCompleted: widget.closeKeyboardOnDone,
        separator: widget.separator,
        cursor: widget.cursor ??
            Container(
              width: 1.1,
              height: 16,
              color: Colors.black.withOpacity(0.75),
            ),
        validator: widget.validator != null
            ? (input) => widget.validator!(context, input)
            : null,
        pinputAutovalidateMode: widget.autoValidate
            ? PinputAutovalidateMode.onSubmit
            : PinputAutovalidateMode.disabled,
      );

  /// Widget built when [widget.useInternalCommunication] is enabled
  Widget _buildPinFieldWithBuilder(BuildContext context) =>
      RxBlocBuilder<SmsCodeBlocType, TemporaryCodeState>(
        state: (bloc) => bloc.states.onCodeVerificationResult,
        builder: (context, verificationResult, bloc) =>
            RxBlocBuilder<SmsCodeBlocType, int>(
          state: (bloc) => bloc.states.pinLength,
          builder: (context, pinLength, bloc) {
            if (verificationResult.data == TemporaryCodeState.reset) {
              _controller ??= TextEditingController();
              _controller?.clear();
            }

            return _buildPinField(
              context,
              forceErrorState:
                  verificationResult.data == TemporaryCodeState.wrong,
              forceSuccessState:
                  verificationResult.data == TemporaryCodeState.correct,
              pinLength: pinLength.data ?? 6,
              readOnly: verificationResult.data == TemporaryCodeState.correct ||
                  verificationResult.data == TemporaryCodeState.loading ||
                  verificationResult.data == TemporaryCodeState.disabled,
              enabled: (widget.enabled != null && widget.enabled == false) ||
                      verificationResult.data == TemporaryCodeState.disabled
                  ? false
                  : verificationResult.data != TemporaryCodeState.correct,
              onCompleted: (value) {
                print(value);
                print(verificationResult.data);
                return context.read<SmsCodeBlocType>().events.verifyCode(value);
              },
            );
          },
        ),
      );

  /// endregion

  /// region Themes and Styling

  PinTheme _buildThemeFromConfigStyle(SmsFieldTheme theme) => PinTheme(
        width: theme.width,
        height: theme.height,
        padding: theme.padding,
        margin: theme.margin,
        textStyle: theme.textStyle,
        decoration: theme.decoration,
        constraints: theme.constraints,
      );

  PinTheme _buildGenericTheme(
    BuildContext context, {
    Color? bgColor,
    Color? borderColor,
    double? borderWidth,
    TextStyle? textStyle,
    bool showBorder = false,
  }) =>
      PinTheme(
        width: 56,
        height: 60,
        decoration: BoxDecoration(
          color: bgColor ?? context.designSystem.colors.pinBgColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: showBorder
              ? Border.all(
                  color: borderColor ??
                      context.designSystem.colors.black.withOpacity(0.5),
                  width: borderWidth ?? 1.5,
                )
              : null,
        ),
        textStyle: textStyle ?? context.widgetToolkitTheme.textButtonTextStyle,
      );

  PinTheme _buildDefaultTheme(BuildContext context) =>
      widget.themeConfig.defaultStyle != null
          ? _buildThemeFromConfigStyle(widget.themeConfig.defaultStyle!)
          : _buildGenericTheme(context);

  PinTheme _buildDisabledTheme(BuildContext context) =>
      widget.themeConfig.disabledStyle != null
          ? _buildThemeFromConfigStyle(widget.themeConfig.disabledStyle!)
          : _buildGenericTheme(
              context,
              bgColor: context.designSystem.colors.pinBgDisabledColor,
              textStyle: context.designSystem.typography.otpPinText,
            );

  PinTheme _buildFocusedTheme(BuildContext context) =>
      widget.themeConfig.focusedStyle != null
          ? _buildThemeFromConfigStyle(widget.themeConfig.focusedStyle!)
          : _buildGenericTheme(
              context,
              showBorder: true,
            );

  PinTheme _buildSubmittedTheme(BuildContext context) =>
      widget.themeConfig.submittedStyle != null
          ? _buildThemeFromConfigStyle(widget.themeConfig.submittedStyle!)
          : _buildGenericTheme(
              context,
              bgColor: context.designSystem.colors.pinBgSubmittedColor,
            );

  PinTheme _buildUnfilledStyleTheme(BuildContext context) =>
      widget.themeConfig.unfilledStyle != null
          ? _buildThemeFromConfigStyle(widget.themeConfig.unfilledStyle!)
          : _buildGenericTheme(
              context,
            );

  PinTheme _buildErrorTheme(BuildContext context) =>
      widget.themeConfig.errorStyle != null
          ? _buildThemeFromConfigStyle(widget.themeConfig.errorStyle!)
          : _buildGenericTheme(
              context,
              showBorder: true,
              bgColor: context.widgetToolkitTheme.errorCardBackgroundColor,
              borderColor: context.designSystem.colors.pinErrorBorderColor,
              borderWidth: 2,
              textStyle: context.designSystem.typography.otpPinText,
            );

  PinTheme _buildSuccessTheme(BuildContext context) =>
      widget.themeConfig.successStyle != null
          ? _buildThemeFromConfigStyle(widget.themeConfig.successStyle!)
          : _buildGenericTheme(
              context,
              showBorder: true,
              bgColor: context.designSystem.colors.pinBgSuccessColor,
              borderColor: context.designSystem.colors.pinSuccessBorderColor,
              borderWidth: 2,
              textStyle: context.designSystem.typography.otpPinText,
            );
}

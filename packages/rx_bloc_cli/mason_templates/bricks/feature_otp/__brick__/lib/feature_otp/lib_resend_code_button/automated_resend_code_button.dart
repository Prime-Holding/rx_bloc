import 'package:flutter/material.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';

import '../../base/extensions/exception_extensions.dart';
import '../lib_countdown_widget/di/countdown_widget.dart';

/// ResendCodeButton maintains its own statuses. Once the button is being
/// pressed, it goes through a few stats (loading, codeSent, disabled, active,
/// error). The button is enabled only in active state. When pressed, it goes in
/// loading state while the [onPressed] is being executed. Loading indicator and
/// [strings.resendButtonLoadingStateLabel] are presented. Then the button
/// automatically goes to codeSent state for [sentStateDuration] presenting
/// [codeSentStateIcon] or its default value and [strings.resendButtonCodeSentStateLabel].
/// Next is disabled state for [disabledDuration] seconds. In disabled state the
/// button displays countDown instead of icon and [strings.resendButtonDisabledStateLabel].
/// After [disabledDuration] time past, the button gets back in active state
/// with [activeStateIcon] and [strings.resendButtonActiveStateLabel]. Right
/// after that, the button will be switched back to the enabled state.
///
/// If an error occur while [onPressed] is executed, the button get in error
/// state instead of codeSent state. [errorStateIcon] and [strings.resendButtonErrorStateLabel]
/// are displayed for [errorStateDuration] seconds. [onError] callback will be
/// executed if provided.
class AutomatedResendCodeButton extends StatefulWidget {
  const AutomatedResendCodeButton({
    required this.onPressed,
    this.onError,
    this.sentStateDuration = 2,
    this.errorStateDuration = 2,
    this.disabledDuration = 30,
    this.textStyle,
    this.buttonColorStyle,
    this.activeStateIcon,
    this.codeSentStateIcon,
    this.errorStateIcon,
    this.loadingStateIcon,
    this.capitalizeLabels = true,
    this.overwriteLoadingIcon = false,
    this.splashEffectEnabled = false,
    super.key,
  });

  /// A callback to be executed once the active button is pressed. Right before
  /// that, the button state will be changed to loading while this Future is
  /// being processed. After that codeSent and disabled states of the button
  /// will be set one after another respective for [sentStateDuration] and
  /// [disabledDuration].
  final Future<void> Function() onPressed;

  /// Callback executed if an error occurs during the [onPressed] event
  final void Function(String)? onError;

  /// How long in seconds sentCodeState of the button will be presented
  /// (defaults to 2 seconds).
  final int sentStateDuration;

  /// How long in seconds errorState of the button will be presented
  /// (defaults to 2 seconds).
  final int errorStateDuration;

  /// Use this to provide a custom textStyle for button labels
  final TextStyle? textStyle;

  /// If button labels will be capitalized, defaults to true
  final bool capitalizeLabels;

  /// The style of the button
  final ButtonColorStyle? buttonColorStyle;

  /// By default if the button is in loading state a CircularProgressIndicator
  /// will be displayed instead of icon. If you want to change this,
  /// set [overwriteLoadingIcon] to true and provide [loadingStateIcon]
  final bool overwriteLoadingIcon;

  /// Set in seconds how long the button will stay in disabled state after the
  /// callback is executed. While that state a countdown counter will be
  /// presented instead an icon.
  final int disabledDuration;

  /// Provide an IconData or other widget
  final dynamic activeStateIcon;

  /// Provide an IconData or other widget. Won't be used if [overwriteLoadingIcon]
  /// is false
  final dynamic loadingStateIcon;

  /// Provide an IconData or other widget
  final dynamic codeSentStateIcon;

  /// Provide an IconData or other widget
  final dynamic errorStateIcon;

  /// Enable splash effect on the button
  final bool splashEffectEnabled;

  @override
  State<AutomatedResendCodeButton> createState() =>
      _AutomatedResendCodeButtonState();
}

class _AutomatedResendCodeButtonState extends State<AutomatedResendCodeButton> {
  late _ResendButtonState _buttonState;

  TextStyle _getDefaultTextStyle(BuildContext context) =>
      context.widgetToolkitTheme.outlineButtonDescriptionTextStyle
          .copyWith(color: getTextColor(context));

  @override
  void initState() {
    _buttonState = _ResendButtonState.active;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_buttonState) {
      case (_ResendButtonState.active):
        return _activeWidget(context);
      case (_ResendButtonState.loading):
        return _loadingWidget(context);
      case (_ResendButtonState.codeSent):
        return _sentCodeWidget(context);
      case (_ResendButtonState.disabled):
        return _disabledWidget(context);
      case (_ResendButtonState.error):
        return _errorWidget(context);
    }
  }

  Widget _loadingWidget(BuildContext context) => _buildResendButton(context,
      text: context.l10n.featureOtp.resendButtonLoadingStateLabel,
      isEnabled: false,
      isLoading: true,
      icon: widget.loadingStateIcon);

  Widget _errorWidget(BuildContext context) => _buildResendButton(context,
      text: context.l10n.featureOtp.resendButtonErrorStateLabel,
      isEnabled: false,
      icon: widget.errorStateIcon ?? Icons.error_outline);

  Widget _sentCodeWidget(BuildContext context) => _buildResendButton(
        context,
        isEnabled: false,
        text: context.l10n.featureOtp.resendButtonCodeSentStateLabel,
        icon: widget.codeSentStateIcon ?? Icons.check_circle_outline,
      );

  Widget _disabledWidget(BuildContext context) => _buildResendButton(
        context,
        isEnabled: false,
        text: context.l10n.featureOtp.resendButtonDisabledStateLabel,
        icon: CountdownWidget(
            countdownTime: widget.disabledDuration,
            onCountdownTick: _onCountDownTick,
            textStyle: _getDefaultTextStyle(context)),
      );

  Widget _activeWidget(BuildContext context) => _buildResendButton(
        context,
        isEnabled: true,
        icon: widget.activeStateIcon ?? Icons.send_rounded,
        text: context.l10n.featureOtp.resendButtonActiveStateLabel,
        onPressed: () async {
          bool getError = false;
          _setButtonState(_ResendButtonState.loading);
          try {
            await widget.onPressed.call();
          } catch (e) {
            getError = true;
            _setButtonState(_ResendButtonState.error);
            widget.onError?.call(e.asErrorString);
          }
          if (!getError) {
            _setButtonState(_ResendButtonState.codeSent);
            await _sentStateDuration();
          } else {
            await _errorStateDuration();
          }
          _setButtonState(_ResendButtonState.disabled);
        },
      );

  Widget _buildResendButton(
    BuildContext context, {
    required bool isEnabled,
    required String text,
    required dynamic icon,
    void Function()? onPressed,
    bool isLoading = false,
  }) =>
      IconTextButton(
        splashEffectEnabled: widget.splashEffectEnabled,
        state: isEnabled ? ButtonStateModel.enabled : ButtonStateModel.disabled,
        icon: (isLoading && !widget.overwriteLoadingIcon)
            ? SizedLoadingIndicator(
                color: getTextColor(context),
                padding: EdgeInsets.zero,
                size: Size(
                  context.widgetToolkitTheme.spacingM,
                  context.widgetToolkitTheme.spacingM,
                ),
                strokeWidth: 3,
              )
            : icon,
        colorStyle: widget.buttonColorStyle ??
            ButtonColorStyle.fromContext(
              context,
              activeGradientColorStart:
                  context.widgetToolkitTheme.backgroundColor,
              activeButtonTextColor:
                  context.widgetToolkitTheme.activeButtonTextColor,
              disabledButtonTextColor:
                  context.widgetToolkitTheme.disabledButtonTextColor,
              pressedColor: context.widgetToolkitTheme.buttonPressedColor,
            ),
        onPressed: isEnabled ? () => onPressed?.call() : null,
        text: widget.capitalizeLabels ? text.toUpperCase() : text,
        textStyle: widget.textStyle ?? _getDefaultTextStyle(context),
      );

  Color getTextColor(BuildContext context) {
    if (_buttonState == _ResendButtonState.active) {
      return widget.buttonColorStyle?.activeButtonTextColor ??
          context.widgetToolkitTheme.activeButtonTextColor;
    } else {
      return widget.buttonColorStyle?.activeButtonTextColor ??
          context.widgetToolkitTheme.disabledButtonTextColor;
    }
  }

  Future<void> _sentStateDuration() =>
      Future.delayed(Duration(seconds: widget.sentStateDuration));

  Future<void> _errorStateDuration() =>
      Future.delayed(Duration(seconds: widget.errorStateDuration));

  void _setButtonState(_ResendButtonState buttonState) => setState(() {
        _buttonState = buttonState;
      });

  void _onCountDownTick(int remainingTime) =>
      remainingTime == 0 ? _setButtonState(_ResendButtonState.active) : null;
}

/// Enum describing different resend button states
enum _ResendButtonState { active, loading, codeSent, disabled, error }

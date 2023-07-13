{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/models.dart';
import 'package:widget_toolkit/ui_components.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../app_extensions.dart';
import '../bloc/pin_bloc.dart';
import 'verify_pin_code_page.dart';

class ConfirmPinPage extends StatefulWidget {
  const ConfirmPinPage({
    this.pinCodeArguments = const PinCodeArguments(
      title: 'Confirm Pin Page',
      isSessionTimeout: false,
    ),
    super.key,
  });

  final PinCodeArguments pinCodeArguments;

  @override
  State<ConfirmPinPage> createState() => _ConfirmPinPageState();
}

class _ConfirmPinPageState extends State<ConfirmPinPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PinBlocType>().events
        ..setPinCodeType(widget.pinCodeArguments.isSessionTimeout)
        ..temporaryDisableBiometrics(true);
    });
    super.initState();
  }

  @override
  void dispose() {
    if (widget.pinCodeArguments.onReturn != null) {
      widget.pinCodeArguments.onReturn!();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.pinCodeArguments.title),
            ),
            extendBodyBehindAppBar: true,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    child: PinCodeKeyboard(
                      mapBiometricMessageToString: (message) =>
                          _exampleMapMessageToString(message, context),
                      pinCodeService: context.read<PinCodeService>(),
                      biometricsLocalDataSource:
                          context.read<BiometricsLocalDataSource>(),
                      translateError: (error) =>
                          _translateError(error, context),
                      onError: (error, translatedError) =>
                          _onError(error, translatedError, context),
                      isPinCodeVerified: (verified) =>
                          _isPinCodeVerified(verified, context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _isPinCodeVerified(
      bool isPinVerified, BuildContext context) async {
    if (isPinVerified) {
      await showBlurredBottomSheet(
        context: context,
        configuration: const ModalConfiguration(safeAreaBottom: false),
        builder: (context) => MessagePanelWidget(
          message: context.l10n.libPinCode.pinVerifiedMessage,
          messageState: MessagePanelState.positiveCheck,
        ),
      );
    }
  }

  void _onError(Object error, String strValue, BuildContext context) {
    if (error is! ErrorWrongPin) {
      showBlurredBottomSheet(
        context: context,
        configuration: const ModalConfiguration(safeAreaBottom: false),
        builder: (context) => MessagePanelWidget(
          message: error.toString(),
          messageState: MessagePanelState.important,
        ),
      );
    }
  }

  String _translateError(Object error, BuildContext context) {
    if (error is ErrorWrongPin) {
      return error.errorMessage;
    }
    return context.l10n.libPinCode.translatedError;
  }

  String _exampleMapMessageToString(
      BiometricsMessage message, BuildContext context) {
    switch (message) {
      case BiometricsMessage.notSetup:
        return context.l10n.libPinCode.biometricsNotSetup;

      case BiometricsMessage.notSupported:
        return context.l10n.libPinCode.biometricsNotSupported;

      case BiometricsMessage.enabled:
        return context.l10n.libPinCode.biometricsEnabled;

      case BiometricsMessage.disabled:
        return context.l10n.libPinCode.biometricsDisabled;
    }
  }
}

{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/models.dart';
import 'package:widget_toolkit/ui_components.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../l10n/l10n.dart';
import '../bloc/pin_bloc.dart';
import '../models/pin_code_arguments.dart';

class VerifyPinCodePage extends StatefulWidget {
  const VerifyPinCodePage({
    this.pinCodeArguments = const PinCodeArguments(
      title: '',
      isSessionTimeout: false,
    ),
    super.key,
  });

  final PinCodeArguments pinCodeArguments;

  @override
  State<VerifyPinCodePage> createState() => _VerifyPinCodePageState();
}

class _VerifyPinCodePageState extends State<VerifyPinCodePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PinBlocType>().events
        ..setPinCodeType(widget.pinCodeArguments.isSessionTimeout)
        ..temporaryDisableBiometrics(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => WillPopScope(
          onWillPop: () async {
            context.read<PinBlocType>().events.deleteSavedData();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.pinCodeArguments.title.isEmpty
                ? context.l10n.libPinCode.verifyPinCodePage
                    : widget.pinCodeArguments.title,
                ),
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
                      isAuthenticatedWithBiometrics: (isAuthWithBiometrics) =>
                          _isAuthenticatedWithBiometrics(
                        isAuthWithBiometrics,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _isAuthenticatedWithBiometrics(
    bool isAuthWithBiometrics,
  ) async {
    if (isAuthWithBiometrics) {
      if (widget.pinCodeArguments.isSessionTimeout) {
        context.read<CoordinatorBlocType>().events.pinCodeConfirmed(
              isPinCodeConfirmed: true,
            );
      }
    }
  }

  Future<void> _isPinCodeVerified(
      bool isPinVerified, BuildContext context) async {
    if (isPinVerified) {
      if (widget.pinCodeArguments.isSessionTimeout) {
        context.read<CoordinatorBlocType>().events.pinCodeConfirmed(
              isPinCodeConfirmed: true,
            );
        return;
      }
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


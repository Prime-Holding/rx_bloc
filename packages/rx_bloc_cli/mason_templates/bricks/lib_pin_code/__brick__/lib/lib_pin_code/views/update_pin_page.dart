{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/models.dart';
import 'package:widget_toolkit/ui_components.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../app_extensions.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../bloc/pin_bloc.dart';
import '../models/pin_code_arguments.dart';

class UpdatePinPage extends StatefulWidget {
  const UpdatePinPage({
    this.pinCodeArguments = const PinCodeArguments(
      title: '',
      isSessionTimeout: false,
    ),
    super.key,
  });

  final PinCodeArguments pinCodeArguments;

  @override
  State<UpdatePinPage> createState() => _UpdatePinPageState();
}

class _UpdatePinPageState extends State<UpdatePinPage> {
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
                    ? context.l10n.libPinCode.updatePinPage
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
      if (widget.pinCodeArguments.title ==
          context.l10n.libPinCode.enterCurrentPin) {
        return context.read<RouterBlocType>().events.pushReplace(
            const UpdatePinRoute(),
            extra:
                PinCodeArguments(title: context.l10n.libPinCode.enterNewPin));
      }
      if (widget.pinCodeArguments.title ==
          context.l10n.libPinCode.enterNewPin) {
        return context.read<RouterBlocType>().events.pushReplace(
            const ConfirmPinRoute(),
            extra: PinCodeArguments(title: context.l10n.libPinCode.confirmPin));
      } else if (widget.pinCodeArguments.title ==
          context.l10n.libPinCode.confirmPin) {
        await showBlurredBottomSheet(
          context: context,
          configuration: const ModalConfiguration(safeAreaBottom: false),
          builder: (context) => MessagePanelWidget(
            message: context.l10n.libPinCode.pinUpdatedMessage,
            messageState: MessagePanelState.positiveCheck,
          ),
        );
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

  String _translateError(Object error, BuildContext context) =>
      error is ErrorWrongPin
          ? error.errorMessage
          : context.l10n.libPinCode.translatedError;

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

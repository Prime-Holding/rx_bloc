{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/extensions/error_model_translations.dart';
import '../../l10n/l10n.dart';
import '../bloc/update_and_verify_pin_bloc.dart';
import '../models/pin_code_arguments.dart';
import '../services/update_and_verify_pin_code_service.dart';

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
      context
          .read<UpdateAndVerifyPinBlocType>()
          .events
          .setPinCodeType(widget.pinCodeArguments.isSessionTimeout);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => PopScope(
          canPop: true,
          onPopInvoked: (didPop) => context
              .read<UpdateAndVerifyPinBlocType>()
              .events
              .deleteSavedData(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.pinCodeArguments.title.isEmpty
                    ? context.l10n.libPinCode.verifyPinCodePage
                    : widget.pinCodeArguments.title,
              ),
              forceMaterialTransparency: true,
            ),
            extendBodyBehindAppBar: true,
            body: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                children: [
                  Expanded(
                    child: PinCodeKeyboard(
                      mapBiometricMessageToString: (message) =>
                          _exampleMapMessageToString(message, context),
                      pinCodeService:
                          context.read<UpdateAndVerifyPinCodeService>(),
// Comment the line bellow in order not to use biometrics
// authentication
                      biometricsLocalDataSource:
                          context.read<BiometricsLocalDataSource>(),
                      translateError: (error) =>
                          error.asErrorModel().translate(context),
                      onAuthenticated: (_) => _isPinCodeVerified(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _isPinCodeVerified(BuildContext context) async {
    if (widget.pinCodeArguments.isSessionTimeout) {
      context.read<CoordinatorBlocType>().events.pinCodeConfirmed(
            isPinCodeConfirmed: true,
          );
    }
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

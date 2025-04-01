{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../app_extensions.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/extensions/error_model_translations.dart';

import '../services/verify_pin_code_service.dart';

class VerifyPinCodePage extends StatelessWidget {
  const VerifyPinCodePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            surfaceTintColor: Colors.red,
            title: Text(
              context.l10n.libPinCode.verifyPinCodePage,
              style: context.designSystem.typography.h1Reg22,
            ),
            foregroundColor: context.designSystem.colors.pinAppBarColor,
            forceMaterialTransparency: true,
          ),
          extendBodyBehindAppBar: true,
          body: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: Column(
              children: [
                Expanded(
                  child: PinCodeKeyboard(
                    autoPromptBiometric: true,
                    mapBiometricMessageToString: (message) =>
                        _exampleMapMessageToString(message, context),
                    pinCodeService: context.read<VerifyPinCodeService>(),
                    biometricsLocalDataSource:
                        context.read<BiometricsLocalDataSource>(),
                    biometricsAuthDataSource:
                        context.read<PinBiometricsAuthDataSource?>(),
                    translateError: (error) =>
                        error.asErrorModel().translate(context),
                    onAuthenticated: (_) {
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
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

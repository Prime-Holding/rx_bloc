{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../app_extensions.dart';
import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/extensions/error_model_translations.dart';
import '../../l10n/l10n.dart';
import '../bloc/update_and_verify_pin_bloc.dart';
import '../models/pin_code_arguments.dart';
import '../services/verify_pin_code_service.dart';

class VerifyPinCodePage extends StatelessWidget {
  const VerifyPinCodePage({
    this.pinCodeArguments = const PinCodeArguments(title: ''),
    super.key,
  });

  final PinCodeArguments pinCodeArguments;

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, dynamic) =>
            context.read<UpdateAndVerifyPinBlocType>().events.deleteSavedData(),
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.red,
            title: Text(
              pinCodeArguments.title.isEmpty
                  ? context.l10n.libPinCode.verifyPinCodePage
                  : pinCodeArguments.title,
              style: context.designSystem.typography.h1Reg22,
            ),
            foregroundColor: context.designSystem.colors.white,
            forceMaterialTransparency: true,
          ),
          extendBodyBehindAppBar: true,
          body: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: Column(
              children: [
                Expanded(
                  child: PinCodeKeyboard(
                    autoBiometricAuth: true,
                    mapBiometricMessageToString: (message) =>
                        _exampleMapMessageToString(message, context),
                    pinCodeService: context.read<VerifyPinCodeService>(),
// Comment the line bellow in order not to use biometrics
// authentication
                    biometricsLocalDataSource:
                        context.read<BiometricsLocalDataSource>(),
                    biometricsAuthDataSource:
                        context.read<PinBiometricsAuthDataSource?>(),
                    translateError: (error) =>
                        error.asErrorModel().translate(context),
                    onAuthenticated: (_) => _isPinCodeVerified(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _isPinCodeVerified(BuildContext context) async {
    context.read<CoordinatorBlocType>().events.pinCodeConfirmed(
          isPinCodeConfirmed: true,
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
}

{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../app_extensions.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/extensions/error_model_translations.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../bloc/update_and_verify_pin_bloc.dart';
import '../models/pin_code_arguments.dart';
import '../services/update_pin_code_service.dart';

class UpdatePinPage extends StatelessWidget {
  const UpdatePinPage({
    this.pinCodeArguments = const PinCodeArguments(title: ''),
    super.key,
  });

  final PinCodeArguments pinCodeArguments;

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, dynamic) => context
            .read<UpdateAndVerifyPinBlocType>()
            .events
            .deleteSavedData(),
        child: Scaffold(
          appBar: AppBar(
          title: Text(
              pinCodeArguments.title.isEmpty
                ? context.l10n.libPinCode.updatePinPage
                  : pinCodeArguments.title,
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
                    mapBiometricMessageToString: (message) =>
                        _exampleMapMessageToString(message, context),
                    pinCodeService:
                        context.read<UpdatePinCodeService>(),
                    biometricsLocalDataSource:
                        pinCodeArguments.showBiometricsButton
                            ? context.read<BiometricsLocalDataSource>()
                            : null,
                    biometricsAuthDataSource:
                        context.read<PinBiometricsAuthDataSource?>(),
                    translateError: (error) =>
                        error.asErrorModel().translate(context),
                    onAuthenticated: (token) =>
                        _isPinCodeVerified(context, token),
                  ),
                ),
                RxBlocListener<UpdateAndVerifyPinBlocType, void>(
                  state: (bloc) => bloc.states.isPinUpdated,
                  listener: (context, isCreated) {
                    context
                        .read<RouterBlocType>()
                        .events
                        .go(const ProfileRoute());
                  },
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _isPinCodeVerified(
    BuildContext context,
    String? updateToken,
  ) async {
    if (pinCodeArguments.title == context.l10n.libPinCode.enterCurrentPin) {
      return context
          .read<RouterBlocType>()
          .events
          .pushReplace(const UpdatePinRoute(),
              extra: PinCodeArguments(
                title: context.l10n.libPinCode.enterNewPin,
                updateToken: updateToken,
              ));
    }
    if (pinCodeArguments.title == context.l10n.libPinCode.enterNewPin) {
      return context
          .read<RouterBlocType>()
          .events
          .pushReplace(const UpdatePinRoute(),
              extra: PinCodeArguments(
                title: context.l10n.libPinCode.confirmPin,
                updateToken: pinCodeArguments.updateToken ?? updateToken,
              ));
    } else if (pinCodeArguments.title == context.l10n.libPinCode.confirmPin) {
      context.read<UpdateAndVerifyPinBlocType>().events.checkIsPinUpdated();
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

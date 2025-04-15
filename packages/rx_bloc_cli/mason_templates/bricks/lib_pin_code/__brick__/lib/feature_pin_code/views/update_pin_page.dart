{{> licence.dart }}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../app_extensions.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/extensions/error_model_translations.dart';

import '../../base/models/pin_code/update_pin_model.dart';
import '../../lib_auth/blocs/user_account_bloc.dart';
import '../../lib_router/router.dart';

import '../services/update_pin_code_service.dart';

class UpdatePinPage extends StatelessWidget {
  const UpdatePinPage({
    required this.pinModel,
    super.key,
  });

  final UpdatePinModel pinModel;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            pinModel.asTitle(context),
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
                  pinCodeService: context.read<UpdatePinCodeService>(),
                  biometricsLocalDataSource: pinModel is UpdatePinVerifyModel
                      ? context.read<BiometricsLocalDataSource>()
                      : null,
                  biometricsAuthDataSource: pinModel is UpdatePinVerifyModel
                      ? context.read<PinBiometricsAuthDataSource?>()
                      : null,
                  translateError: (error) =>
                      error.asErrorModel().translate(context),
                  onAuthenticated: (updatePinModel) =>
                      _onAuthenticated(context, updatePinModel),
                ),
              ),
            ],
          ),
        ),
      );

  void _onAuthenticated(BuildContext context, UpdatePinModel result) {
    // If the pin code is verified we navigate profile page
    if (result case UpdatePinCompleteModel()) {
      context.read<UserAccountBlocType>().events.setCurrentUser(result.user);
      GoRouter.of(context).go(
        const ProfileRoute().routeLocation,
      );
      return;
    }

    unawaited(GoRouter.of(context).pushReplacement(
      UpdatePinRoute().routeLocation,
      extra: result,
    ));
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

extension on UpdatePinModel {
  String asTitle(BuildContext context) => switch (this) {
        UpdatePinVerifyModel() => context.l10n.libPinCode.verifyPinCodePage,
        UpdatePinSetModel() => context.l10n.libPinCode.enterNewPin,
        UpdatePinConfirmModel() => context.l10n.libPinCode.confirmPin,
        UpdatePinCompleteModel() => '',
      };
}

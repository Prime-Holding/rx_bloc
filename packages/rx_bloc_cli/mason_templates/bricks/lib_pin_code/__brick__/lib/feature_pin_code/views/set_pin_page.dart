{{> licence.dart }}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../app_extensions.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/extensions/error_model_translations.dart';

import '../../lib_auth/blocs/user_account_bloc.dart';
import '../../lib_router/router.dart';
import '../models/create_pin_model.dart';
import '../services/create_pin_code_service.dart';

class SetPinPage extends StatelessWidget {
  const SetPinPage({
    required this.pinModel,
    super.key,
  });

  final CreatePinModel pinModel;

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
                  pinCodeService: context.read<CreatePinCodeService>(),
                  translateError: (error) =>
                      error.asErrorModel().translate(context),
                  onAuthenticated: (result) =>
                      _onAuthenticated(context, result),
                ),
              ),
            ],
          ),
        ),
      );

  void _onAuthenticated(BuildContext context, CreatePinModel result) {
    // If the pin code is verified we navigate profile page
    if (result case CreatePinCompleteModel()) {
      context.read<UserAccountBlocType>().events.setCurrentUser(result.user);
      GoRouter.of(context).go(
        const ProfileRoute().routeLocation,
      );
      return;
    }

    unawaited(GoRouter.of(context).pushReplacement(
      const ConfirmPinRoute().routeLocation,
      extra: result,
    ));
  }
}

extension on CreatePinModel {
  String asTitle(BuildContext context) => switch (this) {
        CreatePinSetModel() => context.l10n.libPinCode.createPin,
        CreatePinConfirmModel() => context.l10n.libPinCode.confirmPin,
        CreatePinCompleteModel() => '',
      };
}

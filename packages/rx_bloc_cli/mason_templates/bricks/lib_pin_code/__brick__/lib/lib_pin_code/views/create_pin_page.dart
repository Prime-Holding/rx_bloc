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
import '../bloc/create_pin_bloc.dart';
import '../models/pin_code_arguments.dart';
import '../services/create_pin_code_service.dart';

class CreatePinPage extends StatefulWidget {
  const CreatePinPage({
    this.pinCodeArguments = const PinCodeArguments(title: ''),
    super.key,
  });

  final PinCodeArguments pinCodeArguments;

  @override
  State<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  @override
  void dispose() {
    if (widget.pinCodeArguments.onReturn != null) {
      widget.pinCodeArguments.onReturn!();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
             title: Text(
                widget.pinCodeArguments.title.isEmpty
                  ? context.l10n.libPinCode.createPinPage
                  : widget.pinCodeArguments.title,
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
                    biometricsAuthDataSource:
                        context.read<PinBiometricsAuthDataSource?>(),
                    pinCodeService: context.read<CreatePinCodeService>(),
                    translateError: (error) =>
                        error.asErrorModel().translate(context),
                    onAuthenticated: (_) => _isPinCodeVerified(context),
                  ),
                ),
                RxBlocListener<CreatePinBlocType, bool>(
                  state: (bloc) => bloc.states.isPinCreated,
                  listener: (context, isCreated) {
                    if (isCreated) {
                      context
                          .read<RouterBlocType>()
                          .events
                          .go(const ProfileRoute());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _isPinCodeVerified(BuildContext context) async {
    if (widget.pinCodeArguments.title == context.l10n.libPinCode.createPin) {
      context.read<RouterBlocType>().events.pushReplace(
            const CreatePinRoute(),
            extra: PinCodeArguments(
              title: context.l10n.libPinCode.confirmPin,
              onReturn:
                  context.read<CreatePinBlocType>().events.checkIsPinCreated,
            ),
          );
    } else if (widget.pinCodeArguments.title ==
        context.l10n.libPinCode.confirmPin) {
      context.read<CreatePinBlocType>().events.checkIsPinCreated();
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

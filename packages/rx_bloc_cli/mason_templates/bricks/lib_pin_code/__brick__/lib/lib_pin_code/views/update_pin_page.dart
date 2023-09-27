{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/models.dart';
import 'package:widget_toolkit/ui_components.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../app_extensions.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../bloc/update_and_verify_pin_bloc.dart';
import '../models/pin_code_arguments.dart';
import '../services/update_and_verify_pin_code_service.dart';

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
      context.read<UpdateAndVerifyPinBlocType>().events
        ..setPinCodeType(widget.pinCodeArguments.isSessionTimeout)
        ..setBiometricsEnabled(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => WillPopScope(
          onWillPop: () async {
            context.read<UpdateAndVerifyPinBlocType>().events.deleteSavedData();
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
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                children: [
                  Expanded(
                    child: PinCodeKeyboard(
                      mapBiometricMessageToString: (message) =>
                          _exampleMapMessageToString(message, context),
                      pinCodeService:
                          context.read<UpdateAndVerifyPinCodeService>(),
                      biometricsLocalDataSource:
                          widget.pinCodeArguments.showBiometricsButton
                              ? context.read<BiometricsLocalDataSource>()
                              : null,
                      translateError: (error) =>
                          _translateError(error, context),
                      onError: (error, translatedError) =>
                          _onError(error, translatedError, context),
                      onAuthenticated: () => _isPinCodeVerified(context),
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
        ),
      );

  Future<void> _isPinCodeVerified(BuildContext context) async {
    if (widget.pinCodeArguments.title ==
        context.l10n.libPinCode.enterCurrentPin) {
      return context.read<RouterBlocType>().events.pushReplace(
          const UpdatePinRoute(),
          extra: PinCodeArguments(title: context.l10n.libPinCode.enterNewPin));
    }
    if (widget.pinCodeArguments.title == context.l10n.libPinCode.enterNewPin) {
      return context.read<RouterBlocType>().events.pushReplace(
          const UpdatePinRoute(),
          extra: PinCodeArguments(title: context.l10n.libPinCode.confirmPin));
    } else if (widget.pinCodeArguments.title ==
        context.l10n.libPinCode.confirmPin) {
      context.read<UpdateAndVerifyPinBlocType>().events.checkIsPinUpdated();
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
          ? context.l10n.libPinCode.wrongConfirmationPin
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

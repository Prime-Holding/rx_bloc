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
import '../bloc/pin_bloc.dart';
import '../models/pin_code_data.dart';
import '../services/profile_local_data_source.dart';

class PinCodePage extends StatefulWidget {
  const PinCodePage({
    this.title = 'Pin Code Page',
    super.key,
  });

  final String title;

  @override
  State<PinCodePage> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  late PinCodeData? pinCodeData =
      PinCodeData(isPinCodeCreated: false, isPinCodeUpdated: false);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<BiometricsLocalDataSource>(
            create: (context) => ProfileLocalDataSource(),
          )
        ],
        child: Builder(
          builder: (context) => RxBlocBuilder<PinBlocType, PinCodeData>(
            state: (bloc) => bloc.states.pinCodeData,
            builder: (context, snapshot, bloc) => WillPopScope(
              onWillPop: () async {
                if (snapshot.hasData) {
                  if (!snapshot.data!.isPinCodeCreated) {
                    context.read<PinBlocType>().events.setPinCodeData(
                          PinCodeData(
                            isPinCodeCreated: false,
                            isPinCodeUpdated: false,
                          ),
                        );
                  }
                }
                return true;
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text(widget.title),
                ),
                extendBodyBehindAppBar: true,
                body: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Expanded(
                        child: PinCodeKeyboard(
                          mapBiometricMessageToString:
                              _exampleMapMessageToString,
                          pinCodeService: context.read<PinCodeService>(),
                          biometricsLocalDataSource:
                              context.read<BiometricsLocalDataSource>(),
                          translateError: _translateError,
                          onError: (error, translatedError) =>
                              _onError(error, translatedError, context),
                          isPinCodeVerified: (verified) =>
                              isPinCodeVerified(verified, context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Future<void> isPinCodeVerified(
      bool isPinVerified, BuildContext context) async {
    if (isPinVerified) {
      pinCodeData =
          PinCodeData(isPinCodeCreated: isPinVerified, isPinCodeUpdated: false);

      context.read<PinBlocType>().events.setPinCodeData(pinCodeData!);

      await showBlurredBottomSheet(
        context: context,
        configuration: const ModalConfiguration(safeAreaBottom: false),
        builder: (context) => MessagePanelWidget(
          message: context.l10n.libPinCode.pinCreatedMessage,
          messageState: MessagePanelState.positiveCheck,
        ),
      );
    } else {
      context.read<RouterBlocType>().events.pop();
      context.read<RouterBlocType>().events.push(const PinCodeRoute(),
          extra: context.l10n.libPinCode.confirmPin);
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

  String _translateError(Object error) =>
      error is ErrorWrongPin ? error.errorMessage : 'translated error';

  String _exampleMapMessageToString(BiometricsMessage message) {
    switch (message) {
      case BiometricsMessage.notSetup:
        return 'To use biometrics, you need to turn it on in your device settings!';

      case BiometricsMessage.notSupported:
        return 'You don\'t have biometric feature on your device!';

      case BiometricsMessage.enabled:
        return 'Your biometrics are enabled!';

      case BiometricsMessage.disabled:
        return 'Your biometrics are disabled!';
    }
  }
}

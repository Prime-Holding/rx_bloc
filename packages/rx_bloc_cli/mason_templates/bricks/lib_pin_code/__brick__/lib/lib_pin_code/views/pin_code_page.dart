{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/models.dart';
import 'package:widget_toolkit/ui_components.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../services/app_pin_code_service.dart';
import '../services/profile_local_data_source.dart';

class PinCodePage extends StatelessWidget {
  const PinCodePage({super.key, this.title = 'Pin Code Page'});

  final String title;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<PinCodeService>(
            create: (context) => AppPinCodeService(),
          ),
          Provider<BiometricsLocalDataSource>(
            create: (context) => ProfileLocalDataSource(),
          )
        ],
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            extendBodyBehindAppBar: true,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    child: PinCodeKeyboard(
                      mapBiometricMessageToString: _exampleMapMessageToString,
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
      );

  /// input 111 isPinCodeVerified - return false create the widget again
  /// input 111 isPinCodeVerified - return true - second time
  void isPinCodeVerified(bool isPinVerified, BuildContext context) {
    if (!isPinVerified) {
      context.read<RouterBlocType>().events.pop();
      context.read<RouterBlocType>().events.push(const PinCodeRoute());
    }
    if (isPinVerified) {
      context.read<RouterBlocType>().events.pop();
    }
  }

  void _onError(error, translatedError, context) => showBlurredBottomSheet(
        context: context,
        configuration: const ModalConfiguration(safeAreaBottom: false),
        builder: (context) => const MessagePanelWidget(
          message: 'Could not enable biometric authentication at this time',
          messageState: MessagePanelState.important,
        ),
      );

  String _translateError(Object error) => 'translated error';

  String _exampleMapMessageToString(BiometricsMessage message) {
    switch (message) {
      case BiometricsMessage.notSetup:
        return 'To use biometrics, you need to turn it on in your device'
            ' settings!';

      case BiometricsMessage.notSupported:
        return 'You don\'t have biometric feature on your device!';

      case BiometricsMessage.enabled:
        return 'Your biometrics are enabled!';

      case BiometricsMessage.disabled:
        return 'Your biometrics are disabled!';
    }
  }
}

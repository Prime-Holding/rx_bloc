{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/models.dart';
import 'package:widget_toolkit/ui_components.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

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
                  mapMessageToString: _exampleMapMessageToString,
                  pinCodeService: context.read<PinCodeService>(),
                  biometricsLocalDataSource:
                  context.read<BiometricsLocalDataSource>(),
                  translateError: _translateError,
                  // Optionally you can provide a [localizedReason], this should be
                  // a localized message, which would get shown to the user when they
                  // are prompted to confirm that they want to enable biometrics
                  localizedReason: 'Activate the biometrics of your device',
                  // Optionally you can provide [addDependencies] and set it to false. In
                  // this case you will have to provide and implementation of the [LocalAuthentication],
                  // [PinBiometricsAuthDataSource], [PinBiometricsRepository],[PinCodeBloc]
                  addDependencies: true,
                  // Optionally you can provide [isAuthenticatedWithBiometrics] where the
                  // function receives a bool value showing, whether the user was authenticated with biometrics.
                  isAuthenticatedWithBiometrics: (isAuthenticated) => true,
                  // Optionally you can provide [isPinCodeVerified], where the function
                  // receives a bool value showing, whether pin code is verified.
                  isPinCodeVerified: (isPinCodeVerified) => true,
                  // Optionally you can provide [onError] to handle errors out of the package,
                  // or to show a notification, in practice this would only get called if the
                  // implementations of [BiometricsLocalDataSource.areBiometricsEnabled()],
                  // [BiometricsLocalDataSource.setBiometricsEnabled(enable)],
                  // [PinCodeService.isPinCodeInSecureStorage()], [PinCodeService.encryptPinCode()],
                  // [PinCodeService.getPinLength()], [PinCodeService.verifyPinCode()],
                  //[PinCodeService.getPinCode()], throw.
                  onError: (error, translatedError) =>
                      _onError(error, translatedError, context),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

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

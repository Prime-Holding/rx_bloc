{{> licence.dart }}
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/models.dart';
import 'package:widget_toolkit/ui_components.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../app_extensions.dart';
import '../../base/data_sources/local/shared_preferences_instance.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../bloc/pin_bloc.dart';
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
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<BiometricsLocalDataSource>(
            create: (context) => ProfileLocalDataSource(
              sharedPreferences: context.read<SharedPreferencesInstance>(),
            ),
          )
        ],
        child: Builder(
          builder: (context) => RxBlocBuilder<PinBlocType, bool>(
            state: (bloc) => bloc.states.isAuthenticatedWithBiometrics,
            builder: (context, isAuthenticatedWithBiometrics, bloc) =>
                RxBlocBuilder<PinBlocType, bool>(
              state: (bloc) => bloc.states.isVerificationPinCorrect,
              builder: (context, isVerificationPinCorrect, bloc) {
                if ((isVerificationPinCorrect.hasData &&
                    isVerificationPinCorrect.data!)) {
                  context.read<RouterBlocType>().events.pushReplace(
                      const PinCodeRoute(),
                      extra: context.l10n.libPinCode.enterNewPin);
                } else if ((isVerificationPinCorrect.hasData &&
                    !isVerificationPinCorrect.data!)) {
                  context.read<RouterBlocType>().events.pushReplace(
                      const PinCodeRoute(),
                      extra: context.l10n.libPinCode.confirmPin);
                }
                return RxBlocBuilder<PinBlocType, bool>(
                  state: (bloc) => bloc.states.isPinCreated,
                  builder: (context, isPinCreated, bloc) => WillPopScope(
                    onWillPop: () async {
                      context.read<PinBlocType>().events.deleteSavedData();
                      if (isPinCreated.hasData) {
                        if (!isPinCreated.data!) {
                          context
                              .read<PinBlocType>()
                              .events
                              .setIsPinCreated(false);
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
                                    isPinCodeVerified(isPinCreated, verified,
                                        isVerificationPinCorrect, context),
                                isAuthenticatedWithBiometrics:
                                    (isAuthWithBiometrics) =>
                                        _isAuthenticatedWithBiometrics(
                                            isAuthWithBiometrics,
                                            isAuthenticatedWithBiometrics),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

  Future<void> _isAuthenticatedWithBiometrics(
    bool isAuthWithBiometrics,
    AsyncSnapshot<bool> isAuthenticatedWithBiometrics,
  ) async {
    if (isAuthWithBiometrics) {
      context.read<RouterBlocType>().events.pushReplace(const PinCodeRoute(),
          extra: context.l10n.libPinCode.enterNewPin);
      context.read<PinBlocType>().events.setIsAuthenticatedWithBiometrics(
          isAuthenticatedWithBiometrics: true);
    }
  }

  Future<void> isPinCodeVerified(
      AsyncSnapshot<bool> isPinCreated,
      bool isPinVerified,
      AsyncSnapshot<bool> isVerificationPinCorrect,
      BuildContext context) async {
    if (isPinVerified) {
      context.read<PinBlocType>().events.setIsPinCreated(isPinVerified);
      await showBlurredBottomSheet(
        context: context,
        configuration: const ModalConfiguration(safeAreaBottom: false),
        builder: (context) => MessagePanelWidget(
          message: context.l10n.libPinCode.pinVerifiedMessage,
          messageState: MessagePanelState.positiveCheck,
        ),
      );
    } else {
      if (!isVerificationPinCorrect.hasData) {
        context.read<PinBlocType>().events.setIsVerificationPinCorrect();
      } else {
        context.read<RouterBlocType>().events.pushReplace(const PinCodeRoute(),
            extra: context.l10n.libPinCode.confirmPin);
      }
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

  String _translateError(Object error) {
    if (error is ErrorWrongPin) {
      return error.errorMessage;
    }
    return 'translated error';
  }

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

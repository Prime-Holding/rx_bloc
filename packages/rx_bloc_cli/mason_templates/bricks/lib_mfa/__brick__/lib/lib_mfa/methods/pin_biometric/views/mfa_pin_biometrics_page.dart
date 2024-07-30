{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../../../app_extensions.dart';
import '../../../../base/extensions/error_model_extensions.dart';
import '../../../../base/extensions/error_model_translations.dart';
import '../../../../lib_router/blocs/router_bloc.dart';
import '../../../extensions/exception_extensions.dart';
import '../../../models/mfa_response.dart';
import '../services/mfa_pincode_service.dart';

class MFAPinBiometricsPage extends StatelessWidget {
  const MFAPinBiometricsPage({
    required this.transactionId,
    super.key,
  });

  final String transactionId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.featureMfa.pinBiometrics),
          forceMaterialTransparency: true,
        ),
        extendBodyBehindAppBar: true,
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              Expanded(
                child: PinCodeKeyboard(
                  onError: (error, _) {
                    if (error is Exception && !error.isAuthMethodException) {
                      context
                          .read<RouterBlocType>()
                          .events
                          .pop(Result<MFAResponse>.error(error));
                    }
                  },

                  onAuthenticated: (response) {
                    if (response is MFAResponse) {
                      context
                          .read<RouterBlocType>()
                          .events
                          .pop(Result<MFAResponse>.success(response));
                    }
                  }, // Handle error states
                  pinCodeService: context.read<MFAPinCodeService>(),
                  translateError: (error) =>
                      error.asErrorModel().translate(context),
                ),
              ),
            ],
          ),
        ),
      );
}

{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../../../app_extensions.dart';
import '../../../../lib_router/blocs/router_bloc.dart';
import '../../../extensions/exception_extensions.dart';
import '../../../models/auth_matrix_response.dart';
import '../services/auth_matrix_pincode_service.dart';

class AuthMatrixPinBiometricsPage extends StatelessWidget {
  const AuthMatrixPinBiometricsPage({
    required this.transactionId,
    super.key,
  });

  final String transactionId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.featureAuthMatrix.pinBiometrics),
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
                          .pop(Result<AuthMatrixResponse>.error(error));
                    }
                  },

                  onAuthenticated: () {
                    final authMatrixResponse = context
                        .read<AuthMatrixPinCodeService>()
                        .authMatrixResponse;

                    if (authMatrixResponse != null) {
                      context
                          .read<RouterBlocType>()
                          .events
                          .pop(Result<AuthMatrixResponse>.success(
                            authMatrixResponse,
                          ));
                    }
                  }, // Handle error states
                  pinCodeService: context.read<AuthMatrixPinCodeService>(),
                  translateError: (error) {
                    return error.toString();
                  }, //TODO: Handle error states
                ),
              ),
            ],
          ),
        ),
      );
}

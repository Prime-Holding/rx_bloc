{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../app_extensions.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../bloc/pin_otp_bloc.dart';
import '../models/auth_matrix_response.dart';
import '../services/auth_matrix_service.dart';

class AuthMatrixPinBiometricsPage extends StatelessWidget {
  const AuthMatrixPinBiometricsPage({
    required this.response,
    required this.endToEndId,
    super.key,
  });

  final AuthMatrixResponse response;
  final String endToEndId;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          context
              .read<PinOtpBlocType>()
              .events
              .cancelAuthMatrix(response, endToEndId);
          return true;
        },
        child: Scaffold(
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
                    onError: (error, _) =>
                        context.read<RouterBlocType>().events.pop(),
                    pinCodeService: context.read<AuthMatrixService>(),
                    translateError: (error) => error.toString(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

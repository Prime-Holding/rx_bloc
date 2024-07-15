{{> licence.dart }}

import 'package:flutter/cupertino.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/app/config/app_constants.dart';
import '../bloc/pin_otp_bloc.dart';
import '../models/auth_matrix_response.dart';
import '../views/auth_matrix_pin_biometrics_page.dart';

class AuthMatrixPinBiometricsPageWithDependencies extends StatelessWidget {
  const AuthMatrixPinBiometricsPageWithDependencies({
    required this.response,
    required this.endToEndId,
    super.key,
  });

  final AuthMatrixResponse response;
  final String endToEndId;

  @override
  Widget build(BuildContext context) {
    final current = AuthMatrixPinBiometricsPage(
        response: response,
        endToEndId: endToEndId,
    );


    if (isInTestMode) {
      return current;
    }

    return MultiProvider(
        providers: [
          ..._blocs,
        ],
        child: current,
      );
  }

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<PinOtpBlocType>(
          create: (context) => PinOtpBloc(
            context.read(),
          ),
        ),
      ];
}

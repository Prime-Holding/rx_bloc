{{> licence.dart }}

import 'package:flutter/cupertino.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/pin_otp_bloc.dart';
import '../models/auth_matrix_response.dart';

import '../views/auth_matrix_otp_page.dart';

class AuthMatrixOtpPageWithDependencies extends StatelessWidget {
  const AuthMatrixOtpPageWithDependencies({
    Key? key,
    required this.response,
    required this.endToEndId,
  }) : super(key: key);

  final AuthMatrixResponse response;
  final String endToEndId;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._blocs,
        ],
        child: AuthMatrixOtpPage(
          response: response,
          endToEndId: endToEndId,
        ),
      );

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<PinOtpBlocType>(
          create: (context) => PinOtpBloc(
            context.read(),
          ),
        ),
      ];
}

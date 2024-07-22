{{> licence.dart }}

import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../models/auth_matrix_response.dart';
import '../services/auth_matrix_pincode_service.dart';
import '../views/auth_matrix_pin_biometrics_page.dart';

class AuthMatrixPinBiometricsPageWithDependencies extends StatelessWidget {
  const AuthMatrixPinBiometricsPageWithDependencies({
    required this.transactionId,
    required this.authMatrixResponse,
    super.key,
  });

  final AuthMatrixResponse authMatrixResponse;
  final String transactionId;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
        ],
        child: AuthMatrixPinBiometricsPage(
          transactionId: transactionId,
        ),
      );

  // AuthMatrixPinCodeService
  List<SingleChildStatelessWidget> get _services => [
        Provider<AuthMatrixPinCodeService>(
          create: (context) => AuthMatrixPinCodeService(
            authMatrixResponse: authMatrixResponse,
            authMatrixRepository: context.read(),
          ),
          dispose: (context, service) => service.dispose(),
        ),
      ];
}

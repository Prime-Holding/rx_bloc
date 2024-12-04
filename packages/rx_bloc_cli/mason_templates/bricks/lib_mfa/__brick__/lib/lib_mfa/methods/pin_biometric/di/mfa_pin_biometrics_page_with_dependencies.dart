{{> licence.dart }}

import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../models/mfa_response.dart';
import '../services/mfa_pincode_service.dart';
import '../views/mfa_pin_biometrics_page.dart';

class MfaPinBiometricsPageWithDependencies extends StatelessWidget {
  const MfaPinBiometricsPageWithDependencies({
    required this.transactionId,
    required this.mfaResponse,
    super.key,
  });

  final MfaResponse mfaResponse;
  final String transactionId;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
        ],
        child: MfaPinBiometricsPage(
          transactionId: transactionId,
        ),
      );

  List<SingleChildStatelessWidget> get _services => [
        Provider<MfaPinCodeService>(
          create: (context) => MfaPinCodeService(
            mfaResponse: mfaResponse,
            mfaRepository: context.read(),
            pinCodeRepository: context.read(),
          ),
        ),
      ];
}

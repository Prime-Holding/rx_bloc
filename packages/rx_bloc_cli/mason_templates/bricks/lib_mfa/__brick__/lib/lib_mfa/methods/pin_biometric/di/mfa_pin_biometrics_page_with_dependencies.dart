{{> licence.dart }}

import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../models/mfa_response.dart';
import '../services/mfa_pincode_service.dart';
import '../views/mfa_pin_biometrics_page.dart';

class MFAPinBiometricsPageWithDependencies extends StatelessWidget {
  const MFAPinBiometricsPageWithDependencies({
    required this.transactionId,
    required this.mfaResponse,
    super.key,
  });

  final MFAResponse mfaResponse;
  final String transactionId;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
        ],
        child: MFAPinBiometricsPage(
          transactionId: transactionId,
        ),
      );

  List<SingleChildStatelessWidget> get _services => [
        Provider<MFAPinCodeService>(
          create: (context) => MFAPinCodeService(
            mfaResponse: mfaResponse,
            mfaRepository: context.read(),
          ),
        ),
      ];
}

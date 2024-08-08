{{> licence.dart }}

import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../models/mfa_response.dart';
import '../services/mfa_otp_service.dart';
import '../views/mfa_otp_page.dart';

class MfaOtpPageWithDependencies extends StatelessWidget {
  const MfaOtpPageWithDependencies({
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
        child: MfaOtpPage(
          transactionId: transactionId,
        ),
      );

  List<SingleChildStatelessWidget> get _services => [
        Provider<MfaOtpService>(
          create: (context) => MfaOtpService(
            mfaRepository: context.read(),
            lastMfaResponse: mfaResponse,
          ),
        ),
      ];
}

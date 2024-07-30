{{> licence.dart }}

import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../models/mfa_response.dart';
import '../services/mfa_otp_service.dart';
import '../views/mfa_otp_page.dart';

class MFAOtpPageWithDependencies extends StatelessWidget {
  const MFAOtpPageWithDependencies({
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
        child: MFAOtpPage(
          transactionId: transactionId,
        ),
      );

  List<SingleChildStatelessWidget> get _services => [
        Provider<MFAOtpService>(
          create: (context) => MFAOtpService(
            mfaRepository: context.read(),
            lastMFAResponse: mfaResponse,
          ),
        ),
      ];
}

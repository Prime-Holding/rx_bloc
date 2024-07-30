{{> licence.dart }}

import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../models/tfa_response.dart';
import '../services/tfa_otp_service.dart';
import '../views/tfa_otp_page.dart';

class TFAOtpPageWithDependencies extends StatelessWidget {
  const TFAOtpPageWithDependencies({
    required this.transactionId,
    required this.tfaResponse,
    super.key,
  });

  final TFAResponse tfaResponse;
  final String transactionId;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
        ],
        child: TFAOtpPage(
          transactionId: transactionId,
        ),
      );

  List<SingleChildStatelessWidget> get _services => [
        Provider<TFAOtpService>(
          create: (context) => TFAOtpService(
            tfaRepository: context.read(),
            lastTFAResponse: tfaResponse,
          ),
        ),
      ];
}
